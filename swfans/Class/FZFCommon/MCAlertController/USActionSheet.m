//
//  USActionSheet.m
//  USEvent
//
//  Created by marujun on 15/10/19.
//  Copyright © 2015年 MaRuJun. All rights reserved.
//

#import "USActionSheet.h"

@interface USActionSheetTableCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation USActionSheetTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self setupViews];
    }
    return self;
}

- (void)setupViews
{
    _titleLabel = [[UILabel alloc] initForAutoLayout];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont systemFontOfSize:11];
    _titleLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:_titleLabel];
    [_titleLabel autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    
    self.backgroundColor = [UIColor clearColor];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    self.contentView.backgroundColor = highlighted?HexColor(0xd4d4d4):HexColor(0xeaeaea);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    self.contentView.backgroundColor = selected?HexColor(0xd4d4d4):HexColor(0xeaeaea);
}

@end

@interface USActionSheet() <UITableViewDelegate, UITableViewDataSource>
{
    UILabel *_bgView;
    UITableView *_tableView;
}

@property (nonatomic, copy) void (^completeBlock)(NSInteger buttonIndex);
@property (nonatomic, strong) NSString *cancelButtonTitle;
@property (nonatomic, strong) NSArray *dataSource;

@end

@implementation USActionSheet

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews
{
    _cancelButtonTitle = @"取消";
    
    _bgView = [[UILabel alloc] initForAutoLayout];
    _bgView.userInteractionEnabled = YES;
    _bgView.backgroundColor = RGBACOLOR(0, 0, 0, 0.6);
    [self addSubview:_bgView];
    [_bgView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    
    _tableView = [[UITableView alloc] initForAutoLayout];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.scrollEnabled = NO;
    _tableView.separatorInset = UIEdgeInsetsZero;
    _tableView.separatorColor = [UIColor blackColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self addSubview:_tableView];
    [_tableView autoSetDimension:ALDimensionHeight toSize:130];
    [_tableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disappear)];
    singleTap.numberOfTapsRequired = 1;
    [_bgView addGestureRecognizer:singleTap];
}

- (void)disappear
{
    [self tableView:_tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
}

#pragma mark - Ttable View DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return _dataSource.count;
    }
    return  1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [UIView new];
    headerView.backgroundColor = [UIColor clearColor];
    
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"USActionSheetTableCell";
    
    USActionSheetTableCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[USActionSheetTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    if (indexPath.section == 0) {
        cell.titleLabel.text = _dataSource[indexPath.row];
    } else {
        cell.titleLabel.text = _cancelButtonTitle;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.section == 0) {
        [self clickedIndex:indexPath.row];
    } else {
        [self clickedIndex:_dataSource.count];
    }
}

- (void)clickedIndex:(NSInteger)index
{
    _completeBlock?_completeBlock(index):nil;
    
    CGFloat tableHeight = _tableView.bounds.size.height;
    [UIView animateWithDuration:KeyboardAnimationDuration delay:0.f options:KeyboardAnimationCurve animations:^{
        _bgView.alpha = 0;
        [_tableView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:-tableHeight];
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        _completeBlock = nil;
        [self removeFromSuperview];
    }];
}

+ (instancetype)initWithOtherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION
{
    NSMutableArray *otherTitleArray = [NSMutableArray array];
    va_list _arguments;
    va_start(_arguments, otherButtonTitles);
    for (NSString *key = otherButtonTitles; key != nil; key = (__bridge NSString *)va_arg(_arguments, void *)) {
        [otherTitleArray addObject:key];
    }
    va_end(_arguments);
    
    return [self initWithTitle:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitleArray:otherTitleArray];
}

+ (instancetype)initWithTitle:(NSString *)title
            cancelButtonTitle:(NSString *)cancelButtonTitle
            otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION
{
    NSMutableArray *otherTitleArray = [NSMutableArray array];
    va_list _arguments;
    va_start(_arguments, otherButtonTitles);
    for (NSString *key = otherButtonTitles; key != nil; key = (__bridge NSString *)va_arg(_arguments, void *)) {
        [otherTitleArray addObject:key];
    }
    va_end(_arguments);
    
    return [self initWithTitle:title cancelButtonTitle:cancelButtonTitle destructiveButtonTitle:nil otherButtonTitleArray:otherTitleArray];
}

+ (instancetype)initWithTitle:(NSString *)title
            cancelButtonTitle:(NSString *)cancelButtonTitle
       destructiveButtonTitle:(NSString *)destructiveButtonTitle
            otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION
{
    NSMutableArray *otherTitleArray = [NSMutableArray array];
    va_list _arguments;
    va_start(_arguments, otherButtonTitles);
    for (NSString *key = otherButtonTitles; key != nil; key = (__bridge NSString *)va_arg(_arguments, void *)) {
        [otherTitleArray addObject:key];
    }
    va_end(_arguments);
    
    return [self initWithTitle:title cancelButtonTitle:cancelButtonTitle destructiveButtonTitle:destructiveButtonTitle otherButtonTitleArray:otherTitleArray];
}

+ (instancetype)initWithTitle:(NSString *)title
            cancelButtonTitle:(NSString *)cancelButtonTitle
       destructiveButtonTitle:(NSString *)destructiveButtonTitle
        otherButtonTitleArray:(NSArray *)otherButtonTitleArray
{
    USActionSheet *sheetView = [[USActionSheet alloc] init];
    if (cancelButtonTitle) {
        sheetView.cancelButtonTitle = cancelButtonTitle;
    }
    NSMutableArray *dataSource = [otherButtonTitleArray mutableCopy];
    if (destructiveButtonTitle) {
        [dataSource insertObject:destructiveButtonTitle atIndex:0];
    }
    sheetView.dataSource = dataSource;
    
    return sheetView;
}

- (void)showWithCompletionBlock:(void (^)(NSInteger buttonIndex))completionBlock
{
    _completeBlock = completionBlock;
    
    [[UIApplication topMostWindow] addSubview:self];
    [self autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    
    CGFloat tableHeight = [self tableView:_tableView heightForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]]*(_dataSource.count+1);
    tableHeight += [self tableView:_tableView heightForHeaderInSection:0]*[self numberOfSectionsInTableView:_tableView];
    [_tableView autoSetDimension:ALDimensionHeight toSize:tableHeight];
    
    _bgView.alpha = 0;
    [_tableView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:-tableHeight];
    [self layoutIfNeeded];
    
    [UIView animateWithDuration:KeyboardAnimationDuration delay:0.f options:KeyboardAnimationCurve animations:^{
        _bgView.alpha = 1;
        [_tableView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
        [self layoutIfNeeded];
    } completion:nil];
}

- (void)dealloc
{
    DLOG(@"%@ dealloc",NSStringFromClass([self class]));
}

@end
