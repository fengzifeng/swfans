//
//  MCNewAccostViewController.m
//  MCFriends
//
//  Created by fengzifeng on 15/7/15.
//  Copyright (c) 2015年 fengzifeng. All rights reserved.
//

#import "MCNewsViewController.h"
#import "SwitchView.h"
#import "MCNewsBaseViewController.h"
#import "HMSegmentedControl.h"
#import "FFNewsModel.h"
#import "News.h"
#import "FFNewsCollectionViewCell.h"

static NSString *cellIdentifier1 = @"FFNewsCollectionViewCell";

@interface MCNewsViewController ()<UIScrollViewDelegate>

{
    NSArray *_sourseArray;
    NSInteger _currentPage;
    NSMutableArray *_dataArray;
}

@property (nonatomic, strong) HMSegmentedControl *subjectSC;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, assign) NSInteger selectedSubjectIndex;// 目前选择的科目

@end

@implementation MCNewsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
          }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _sourseArray = @[@"游戏新闻",@"赛事新闻",@"战队新闻",@"行业新闻"];
    _dataArray = [NSMutableArray new];
    
    [self.view addSubview:self.subjectSC];
    [self.view addSubview:self.collectionView];
    if (![self fetchEventListData].count) {
        [self saveData];
    } else {
        [self.collectionView reloadData];
    }
 }

- (void)saveData
{
    //模拟数据
    NSMutableArray *newsArray = [NSMutableArray new];
    for (int i = 0; i < 80; i++) {
        FFNewsModel *model = [[FFNewsModel alloc] initWithObject:@{@"news_type":@(arc4random()%5),@"cell_type":@((arc4random()%5)+1),@"id":@(i)}];
        [newsArray addObject:model];
    }
    
    [News performBlock:^(NSManagedObjectContext *context) {
        
        for (FFNewsModel *model in newsArray) {
            News *news = [News fetchOrInsertSingleInContext:context predicate:@"id==%i",model.id];
            [news populateWithDictionary:model.dictionary];
            
            NSLog(@"cell == %@",news.cell_type);
            
        }
    } complete:^(BOOL success) {
        [self fetchEventListData];
        [self.collectionView reloadData];
    }];
}

- (NSArray *)filterData:(NSNumber *)type
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"news_type==%@",type];
    return [_dataArray filteredArrayUsingPredicate:predicate];
}

- (NSArray *)fetchEventListData
{
    NSArray *modelArray = [News fetchInBgWithRequest:nil];
    _dataArray = [FFNewsModel modelListWithArray:modelArray];
    
    return _dataArray;
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,44 + 64, SCREEN_WIDTH, SCREEN_HEIGHT - 44 - 64 - 49) collectionViewLayout:layout];
        
        [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        [_collectionView registerNib:[UINib nibWithNibName:cellIdentifier1 bundle:nil] forCellWithReuseIdentifier:cellIdentifier1];
        
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.clipsToBounds = YES;
        _collectionView.scrollsToTop = NO;
        _collectionView.pagingEnabled = YES;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        _collectionView.showsHorizontalScrollIndicator = NO;
        
        [self.view insertSubview:_collectionView atIndex:0];
    }
    
    return _collectionView;
}

- (HMSegmentedControl *)subjectSC{
    
    if (!_subjectSC) {
        _subjectSC = [[HMSegmentedControl alloc] initWithSectionTitles: @[@"游戏新闻",@"赛事新闻",@"战队新闻",@"行业新闻"]];
        [_subjectSC setTextColor:HexColor(0x333333)];
        [_subjectSC setFont: kFont_14];
        if (IS_IPHONE_6P){
            [_subjectSC setFont: kFont_16];
        }
        [_subjectSC setSelectionIndicatorColor:HexColor(0x6bbd3d)];
        [_subjectSC setSelectionIndicatorMode: HMSelectionIndicatorFillsSegment];
        [_subjectSC setFrame: CGRectMake(0,64, SCREEN_WIDTH, 44)];
        [_subjectSC setSelectedIndex:0];
        [_subjectSC addTarget: self
                       action: @selector(selectedSubjectIndex:)
             forControlEvents: UIControlEventValueChanged];
    }
    
    return _subjectSC;
}

-(void)selectedSubjectIndex:(id)sender
{
    HMSegmentedControl *theSC = (HMSegmentedControl *)sender;
    NSInteger curIndex = theSC.selectedIndex;
    
    if (curIndex == self.selectedSubjectIndex) return;
    self.selectedSubjectIndex = curIndex;
    
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.selectedSubjectIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
}

- (void)setSegmentViewSlectedIndex:(NSInteger)index{
    if (index == self.selectedSubjectIndex) return;
    
    self.selectedSubjectIndex = index;
    [self.subjectSC setSelectedIndex:index animated:YES];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _sourseArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FFNewsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier1 forIndexPath:indexPath];
    [cell reloadView:[self filterData:@(indexPath.row)]];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(SCREEN_WIDTH , collectionView.height);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    NSInteger page = roundf(scrollView.contentOffset.x / scrollView.frame.size.width);
    page = MAX(page, 0);
    page = MIN(page, _sourseArray.count - 1);
    [self setSegmentViewSlectedIndex:page];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.parentViewController.title = @"新闻";
}

@end
