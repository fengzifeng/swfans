//
//  MCFeedbackViewController.m
//  MCFriends
//
//  Created by fengzifeng on 14-8-19.
//  Copyright (c) 2014年 fengzifeng. All rights reserved.
//

#import "MCFeedbackViewController.h"
#import "UMFeedbackTableCell.h"

@interface MCFeedbackViewController ()
{
    NSMutableArray *_dataSource;
    
    UIView *maskView;
    NSTimer *timer;
    MJRefreshHeader *_header;
}

@property(nonatomic, assign)BOOL scrollToBottom;
@property(nonatomic, strong)UMFeedback *feedbackClient;

@end

@implementation MCFeedbackViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _dataSource = [NSMutableArray array];
        _feedbackClient = [UMFeedback sharedInstance];
        
        //是否有新的友盟问题反馈
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getFinishedWithError:)  name:UMFBGetFinishedNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(postFinishedWithError:) name:UMFBPostFinishedNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:nil];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"联系我们";
    [self setNavigationBackButtonDefault];
    
    chatTextField.layer.borderWidth = 0.5;
    chatTextField.layer.cornerRadius = 3;
    chatTextField.layer.borderColor =  [RGBCOLOR(193, 196, 199) CGColor];
    
    UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 8, 8)];
    leftLabel.backgroundColor = [UIColor clearColor];
    chatTextField.leftView = leftLabel;
    chatTextField.leftViewMode = UITextFieldViewModeAlways;
    
    if ([self.navigationController isEqual:TAB_VC.navigationController]) {
        _tableView.contentInset = UIEdgeInsetsMake(_topInset, 0, 0, 0);
    }else{
        _tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    }
    
//    __weak typeof(self) weakSelf = self;
//    MJRefreshUSHeader *refreshHeader = [MJRefreshUSHeader headerWithRefreshingBlock:^{
//        weakSelf.scrollToBottom = false;
//        [weakSelf.feedbackClient get];
//    }];
//    _tableView.mj_header = refreshHeader;
    
    
    _scrollToBottom = true;
    [self parseTopicAndReplies:[_feedbackClient.topicAndReplies copy]];
    
    [self textFieldDidChange:nil];
    
    NSString *osVersion = [[UIDevice currentDevice] systemVersion];
    NSString *clinetVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [_feedbackClient setRemarkInfo:@{@"iOS":osVersion,@"越狱":[UIDevice jailbroken]?@"是":@"否"}];
    [_feedbackClient updateUserInfo:@{@"contact": @{@"uid":_loginUser.uid?:@"visitor",@"name":_loginUser.nickname?:@"游客",@"version":clinetVersion}}];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(checkFeedback)  userInfo:nil repeats:YES];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [_feedbackClient get];
    });
    

}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)checkFeedback
{
    if(_dataSource.count){
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [_feedbackClient get];
        });
    }
}

- (void)changOffsetWithBottom:(float)bottom
{
    float maxTabelHeight = SCREEN_HEIGHT-64-bottom-chatView.frame.size.height;
    
    float difference = _tableView.contentSize.height - maxTabelHeight;
    if (difference>0) {
        [_tableView setContentOffset:CGPointMake(0, difference)];
    }
}

- (IBAction)sendButtonAction:(UIButton *)sender
{
    [chatTextField resignFirstResponder];
    
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *tempString = [chatTextField.text stringByTrimmingCharactersInSet:whitespace];
    
    if (tempString.length) {
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
        [dictionary setObject:chatTextField.text forKey:@"content"];
        
        [_feedbackClient post:dictionary];
    }else{
        chatTextField.text = @"";
        [self textFieldDidChange:nil];
    }
}


- (void)parseTopicAndReplies:(NSArray *)array
{
    for (NSDictionary *item in array) {
        NSMutableDictionary *dic = [@{@"content":item[@"content"]} mutableCopy];
        [dic setObject:item[@"type"]forKey:@"type"];
        
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[item[@"created_at"] doubleValue]/1000.f];
        [dic setObject:date forKey:@"date"];
        [dic setObject:item[@"is_failed"] forKey:@"is_failed"];
        [_dataSource addObject:dic];
    }
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES];
    [_dataSource sortUsingDescriptors:@[sort]];
    
    [_tableView reloadData];
    if (_scrollToBottom) {
        [self changOffsetWithBottom:0];
    }
}


#pragma mark Umeng Feedback delegate
- (void)getFinishedWithError:(NSNotification *)note
{
    NSError *error = note.object;
    
//    [_tableView.mj_header endRefreshing];
    
    if (!error) {
        
        if ([_feedbackClient.theNewReplies count]) {
            _scrollToBottom = true;
            FLOG(@"有%@条新反馈回复", @([_feedbackClient.theNewReplies count]));
        }else{
            _scrollToBottom = false;
        }
        
        _dataSource = [NSMutableArray array];
        [self parseTopicAndReplies:[_feedbackClient.topicAndReplies copy]];
        
        [userDefaults setObject:@(false) forKey:UserDefaultKey_devFeedback];
        [userDefaults synchronize];
        
    }
    
    FLOG(@"getFinishedWithError: %@",error);
}

- (void)postFinishedWithError:(NSNotification *)note
{
    NSError *error = note.object;
    FLOG(@"postFinishedWithError: %@",error);

    _dataSource = [NSMutableArray array];
    [self parseTopicAndReplies:[_feedbackClient.topicAndReplies copy]];
    [self changOffsetWithBottom:0];
    
    chatTextField.text = @"";
    [maskView removeFromSuperview];
    [self textFieldDidChange:nil];
}


#pragma mark - tableView dataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [UMFeedbackTableCell heightWithData:_dataSource[indexPath.row]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"UMFeedbackTableCell";
    UMFeedbackTableCell *messageCell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (messageCell == nil) {
        messageCell = [[[NSBundle mainBundle] loadNibNamed:identifier owner:self options:nil] firstObject];
    }
    [messageCell initWithData:_dataSource[indexPath.row] indexPath:indexPath];
    
    return messageCell;
}

#pragma mark -textView Delegate
- (void)textFieldDidChange:(NSNotification *)notification
{
    if (!chatTextField.text.length) {
        sendButton.userInteractionEnabled = false;
        [sendButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }else{
        sendButton.userInteractionEnabled = true;
        [sendButton setTitleColor:RGBCOLOR(1, 113, 239) forState:UIControlStateNormal];
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self sendButtonAction:sendButton];
    
    return true;
}

#pragma mark - 键盘升起，下降
- (void)keyboardWillShow:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize keyboardRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    CGRect rect = chatView.frame;
    rect.origin.y = SCREEN_HEIGHT-keyboardRect.height-rect.size.height;
    
    [self addMaskView];
    [self changOffsetWithBottom:keyboardRect.height];
    [self changOffsetWithBottom:0];
    
    [UIView animateWithDuration:KeyboardAnimationDuration delay:0 options:KeyboardAnimationCurve animations:^{
        chatView.frame = rect;
        [self changOffsetWithBottom:keyboardRect.height];
        [_tableView setContentInset:UIEdgeInsetsMake(_tableView.contentInset.top,0,keyboardRect.height,0)];
    } completion:nil];
}

- (void)keyboardWillHide:(NSNotification*)aNotification
{
    CGRect rect = chatView.frame;
    rect.origin.y = SCREEN_HEIGHT-rect.size.height;
    
    [UIView animateWithDuration:KeyboardAnimationDuration delay:0 options:KeyboardAnimationCurve animations:^{
        chatView.frame = rect;
        [self changOffsetWithBottom:0];
        [_tableView setContentInset:UIEdgeInsetsMake(_tableView.contentInset.top,0,0,0)];
    } completion:nil];
}

- (void)addMaskView
{
    if (!maskView) {
        maskView = [[UIView alloc] initWithFrame:KeyWindow.bounds];
        maskView.backgroundColor = [UIColor clearColor];
        __weak typeof(maskView) weakMask = maskView;
        __weak typeof(chatTextField) weakTextField = chatTextField;
        [maskView setTapActionWithBlock:^{
            [weakMask removeFromSuperview];
            [weakTextField resignFirstResponder];
        }];
    }
    
    [self.view insertSubview:maskView belowSubview:chatView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if ([timer isValid]) {
        [timer invalidate];
    }
    timer = nil;
}

@end
