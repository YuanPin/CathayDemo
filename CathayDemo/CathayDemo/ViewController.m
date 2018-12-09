//
//  ViewController.m
//  CathayDemo
//
//  Created by 廖原彬 on 2018/12/5.
//

#import "ViewController.h"
#import "VegetationManager.h"
#import "VegetationTableViewCell.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource, UITableViewDataSourcePrefetching, UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *contentViewTopConstraint;
@property (strong, nonatomic) IBOutlet UIView *infoView;
@property (strong, nonatomic) IBOutlet UILabel *infoTitleLabel;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UIView *contentTitleLabel;
@property (assign, nonatomic) CGFloat infoViewHeight;
@property (assign, nonatomic) CGFloat realOffsetY;

@property (strong, nonatomic, nullable) NSMutableArray *dataArray;
@property (assign, nonatomic) int loadCount;
@property (assign, nonatomic) BOOL hasNextPage;
@property (strong, nonatomic) UIRefreshControl *refreshControl;

@end

@implementation ViewController

static NSString *vegetationCellIdentifier = @"com.cathay.CathayDemo.Vegetation";
static int loadPage = 20;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.tableView.prefetchDataSource = self;
    self.loadCount = 0;
    self.hasNextPage = YES;
    [self setupTableViewCell];
    [self.indicator startAnimating];
    [self fetchData:^{
        [self.indicator stopAnimating];
    }];
}

-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.infoViewHeight = self.infoView.frame.size.height;
}

- (void)setupTableViewCell {
    self.refreshControl = [[UIRefreshControl alloc]init];
    [self.refreshControl addTarget:self action:@selector(refreshAction) forControlEvents:UIControlEventValueChanged];
    self.tableView.refreshControl = self.refreshControl;
    self.tableView.estimatedRowHeight = 640;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView registerNib:[UINib nibWithNibName:@"VegetationTableViewCell" bundle:nil] forCellReuseIdentifier:vegetationCellIdentifier];
}

-(void)refreshAction {
    self.loadCount = 0;
    self.hasNextPage = YES;
    [self.dataArray removeAllObjects];
    [self fetchData:^{
        [self.refreshControl endRefreshing];
    }];
}

-(void)fetchData:(void(^)(void))completionHandler {
    int index = self.loadCount + loadPage;
    __weak typeof(self) weakSelf = self;
    [VegetationManager fetchVegetationDataCount:loadPage StartIndex:self.loadCount completionHandler:^(NSArray * _Nullable resultArray, NSError * _Nullable error) {
        if (error != nil || resultArray == nil) {
            [weakSelf showErrorAlert:error];
            completionHandler();
        } else if (resultArray.count == 0){
            weakSelf.hasNextPage = NO;
            completionHandler();
        }else {
            if (weakSelf.dataArray == nil){
                weakSelf.dataArray = [NSMutableArray new];
            }
            [weakSelf.dataArray addObjectsFromArray:resultArray];
            [weakSelf.tableView reloadData];
            weakSelf.loadCount = index;
            completionHandler();
        }
    }];
}

- (void) showErrorAlert:(NSError * _Nullable)error {
    NSString *errorMessage = @"無法取得資料";
    if (error != nil && error.description != nil) {
        errorMessage = error.description;
    }
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"取得資料失敗"
                                                                   message:errorMessage
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *retry = [UIAlertAction actionWithTitle:@"重試" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self fetchData:nil];
    }];
    [alert addAction:cancel];
    [alert addAction:retry];
    [self presentViewController:alert animated:YES completion:nil];
}


#pragma mark - UITableViewDataSource

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    VegetationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:vegetationCellIdentifier];
    cell.vegetationDataModel = (TaipeiZooVegetationModel *)self.dataArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.dataArray.count;
    }
    return 0;
}

#pragma mark - UITableViewDataSourcePrefetching

- (void)tableView:(UITableView *)tableView prefetchRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths {
    NSIndexPath *path = indexPaths.lastObject;
    if (path.section == 0) {
        if ((path.row == self.dataArray.count - 1) && self.hasNextPage) {
            [self.indicator startAnimating];
            [self fetchData:^{
                [self.indicator stopAnimating];
            }];
        }
    }
}

#pragma mark - UIScrollView Delegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y < 0) {
        if (self.realOffsetY > 0) {
            self.realOffsetY = self.realOffsetY + scrollView.contentOffset.y;
            scrollView.contentOffset = CGPointZero;
            self.contentViewTopConstraint.constant = [self calculateContentViewTopConstraint];;
        } else {
            self.realOffsetY = 0;
        }
    } else {
        if (self.realOffsetY < self.infoViewHeight) {
            self.realOffsetY = self.realOffsetY + scrollView.contentOffset.y;
            scrollView.contentOffset = CGPointZero;
            self.contentViewTopConstraint.constant = [self calculateContentViewTopConstraint];
        } else {
            self.realOffsetY = self.infoViewHeight;
        }
    }
    [self setHeaderTextLabelAlpha];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (self.realOffsetY > 0 &&
        self.realOffsetY <= self.infoViewHeight/2) {
        
        [UIView animateWithDuration:0.2 animations:^{
            self.contentViewTopConstraint.constant = 0;
            [self.view layoutIfNeeded];
        }];
        
        self.realOffsetY = 0;
    } else if (self.realOffsetY < self.infoViewHeight &&
               self.realOffsetY > self.infoViewHeight/2) {
        
        [UIView animateWithDuration:0.2 animations:^{
            self.contentViewTopConstraint.constant = -self.infoViewHeight;
            [self.view layoutIfNeeded];
        }];
        
        self.realOffsetY = self.infoViewHeight;
    }
    
    [self setHeaderTextLabelAlpha];
}

-(CGFloat)calculateContentViewTopConstraint {
    return  (-self.infoViewHeight > -self.realOffsetY) ? -self.infoViewHeight : -self.realOffsetY;
}

-(void)setHeaderTextLabelAlpha {
    
    self.contentTitleLabel.alpha = (self.realOffsetY / self.infoViewHeight);
    self.infoTitleLabel.alpha = 1 - self.contentTitleLabel.alpha;
    
}

@end

