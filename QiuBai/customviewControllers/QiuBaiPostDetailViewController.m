//
//  QiuBaiPostDetailViewController.m
//  QiuBai
//
//  Created by PengPremium on 16/4/8.
//  Copyright © 2016年 pi-lot.org. All rights reserved.
//

#import "QiuBaiPostDetailViewController.h"
#import "QiuBaiPostTableViewCell.h"
#import "QiuBaiCommentTableViewCell.h"

@interface QiuBaiPostDetailViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView* postTableView;
@property (strong, nonatomic) IBOutlet UIView* commentsView;
@end

@implementation QiuBaiPostDetailViewController

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super init];
    if (self) {
        self.automaticallyAdjustsScrollViewInsets = NO;

        frame.origin.x = frame.origin.y = 0;
        self.postTableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        [self.postTableView registerNib:[UINib nibWithNibName:@"QiuBaiPostTableViewCell" bundle:nil]
                 forCellReuseIdentifier:@"QiuBaiPostTableViewCell"];
        self.postTableView.dataSource = self;
        self.postTableView.delegate = self;
        self.postTableView.bounces = NO;
        self.postTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        self.postTableView.bouncesZoom = NO;

        [self.view addSubview:self.postTableView];

        CGRect restFrame = self.view.frame;
        restFrame.origin.y = frame.size.height;
        restFrame.size.height -= frame.size.height;
        self.commentsView = [[UIView alloc] initWithFrame:restFrame];
        [self.view addSubview:self.commentsView];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setPost:(QiuBaiPost *)post {
    _post = post;
    self.navigationItem.title = [NSString stringWithFormat:@"糗事%llu", post.postID];
    CGRect allCommentsTableViewFrame = self.commentsView.frame;
    allCommentsTableViewFrame.origin.x = allCommentsTableViewFrame.origin.y = 0;
    UITableView* allCommentsTableView = [[UITableView alloc] initWithFrame:allCommentsTableViewFrame];
    [allCommentsTableView registerNib:[UINib nibWithNibName:@"QiuBaiCommentTableViewCell" bundle:nil]
               forCellReuseIdentifier:@"QiuBaiCommentTableViewCell"];
    allCommentsTableView.dataSource = self;
    allCommentsTableView.delegate = self;
    allCommentsTableView.bounces = NO;
    [self.commentsView addSubview:allCommentsTableView];

    [allCommentsTableView reloadData];
    [self.postTableView reloadData];
}


#pragma mark - UITableView Data Source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.postTableView) {
        return 1;
    }
    return self.post.comments.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.postTableView) {
        QiuBaiPostTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"QiuBaiPostTableViewCell"];
        [cell setUpWith:self.post];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }

    QiuBaiCommentTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"QiuBaiCommentTableViewCell"];
    [cell setupWith:[self.post.comments.allObjects objectAtIndex:indexPath.row]];
    return cell;
}

#pragma mark - UITableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.postTableView) {
        QiuBaiPostTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"QiuBaiPostTableViewCell"];
        return [cell contentLabelHeightWithPost:self.post] + [cell staticHeight];
    }

    QiuBaiCommentTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"QiuBaiCommentTableViewCell"];
    return [cell heightWith:self.post.comments.allObjects[indexPath.row]];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
