//
//  FFInputePostViewController.m
//  FZFBase
//
//  Created by fengzifeng on 2017/8/26.
//  Copyright © 2017年 fengzifeng. All rights reserved.
//

#import "FFInputePostViewController.h"
#import "MCAboutMeViewController.h"
#import "FFPlateModel.h"
#import "FFActiveChooseView.h"

@interface FFInputePostViewController ()  <UITextViewDelegate,UITextFieldDelegate>

@property (nonatomic, copy) NSString *fid;

@end

@implementation FFInputePostViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if ([super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
        
    }
    
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _textField.returnKeyType = UIReturnKeyDone;
    _textField.delegate = self;
    
    _textView.placeholder = @"写文章…";
    _textView.delegate = self;
    _textView.returnKeyType = UIReturnKeyDone;
    
    UIButton *leftButton = [UIButton newBackArrowNavButtonWithTarget:self action:@selector(clickLeft)];
    [self setNavigationLeftView:leftButton];
    UIButton *rightButton = [UIButton newCloseButtonWithTarget:self action:@selector(clickRight)];
    [self setNavigationRightView:rightButton];
    __weak typeof(self) weakSelf = self;

    [self.view setTapActionWithBlock:^{
        [weakSelf.view endEditing:YES];
    }];
    
    [self requestData];
}

- (FFPlateModel *)requestData
{
    NSDictionary *dict = [userDefaults objectForKey:UserDefaultKey_plateData];

    if (dict.allKeys.count) return [FFPlateModel objectWithKeyValues:dict];
;
    
    [[DrHttpManager defaultManager] getRequestToUrl:url_structedgroups params:nil complete:^(BOOL successed, HttpResponse *response) {
        if (successed) {
            [userDefaults setObject:response.payload forKey:UserDefaultKey_plateData];
        }
    }];
    return nil;
}

- (void)clickRight
{
    [self.view endEditing:YES];

    if (!self.fid.length) {
        [USSuspensionView showWithMessage:@"请选择分区"];
        return;
    } else if (!_textView.text.length) {
        [USSuspensionView showWithMessage:@"请填写内容"];
        return;
    }
    
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@/%@/api/%@/%@",url_submitpost,_loginUser.username,_loginUser.signCode,_textView.text,_fid];

    [[DrHttpManager defaultManager] getRequestToUrl:requestUrl params:nil complete:^(BOOL successed, HttpResponse *response) {
        if (successed) {
            if ([response.payload[@"data"][@"status"] integerValue] == 1) {
                [USSuspensionView showWithMessage:@"发帖成功"];
                [self dismissViewControllerAnimated:YES completion:nil];
            } else {
                [USSuspensionView showWithMessage:@"发帖失败"];
            }
            
        } else {
            [USSuspensionView showWithMessage:@"发帖失败"];
        }
    }];
    
}

- (void)clickLeft
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


- (void)textFieldDidChange:(NSNotification *)not
{
    UITextField * textField =  not.object;
    if (![textField isEqual:_textField]) {
        return;
    }
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    //    [self didClick:nil];
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        //        [self didClick:nil];
        return NO;
    }
    
    
    return YES;
}

- (IBAction)clickChoose:(id)sender
{
    [self.view endEditing:YES];
    FFPlateModel * model = [self requestData];

    if (model.data.count) {
        NSMutableArray *strArray = [NSMutableArray new];
        
        for (FFPlateSectionModel *sectionModel in model.data) {
            for (FFPlateItemModel *itemModel in sectionModel.forums) {
                [strArray addObject:itemModel];
            }
        }
        
        [FFActiveChooseView showActiveChooseView:strArray choose:^(FFPlateItemModel *model) {
            self.fid = model.fid;
            [_chooseBtn setTitle:model.oriName forState:UIControlStateNormal];
            [_chooseBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }];
//        for (FFPlateSectionModel *itemModel in model.data) {
//            [strArray addObject:itemModel.name];
//        }
//        USActionSheet *actionSheet = [USActionSheet initWithTitle:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitleArray:strArray];
//        [actionSheet showWithCompletionBlock:^(NSInteger buttonIndex) {
//            if (buttonIndex < model.data.count) {
//                FFPlateSectionModel *itemModel = model.data[buttonIndex];
//                self.fid = itemModel.fid;
//                [_chooseBtn setTitle:itemModel.name forState:UIControlStateNormal];
//                [_chooseBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//            }
//         }];
    }

}



@end
