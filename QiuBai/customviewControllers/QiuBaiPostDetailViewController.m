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
#import "QiuBaiTablikeSwitch.h"

@interface QiuBaiPostDetailViewController ()
@property (strong, nonatomic)   IBOutlet    QiuBaiTablikeSwitch* commentTypeSwitch;
@property (strong, nonatomic)   NSArray*    allComments;
@property (strong, nonatomic)   NSArray*    hotComments;

@property (strong, nonatomic)   NSArray*    displayComments;
@end

@implementation QiuBaiPostDetailViewController

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        self.tableView.tableHeaderView = nil;
        self.automaticallyAdjustsScrollViewInsets = NO;
        [self.tableView registerNib:[UINib nibWithNibName:@"QiuBaiPostTableViewCell" bundle:nil]
             forCellReuseIdentifier:@"QiuBaiPostTableViewCell"];
        [self.tableView registerNib:[UINib nibWithNibName:@"QiuBaiCommentTableViewCell" bundle:nil]
             forCellReuseIdentifier:@"QiuBaiCommentTableViewCell"];
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
    [self commentTypeChanged:nil];
}


#pragma mark - UITableView Data Source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return self.displayComments.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        QiuBaiPostTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"QiuBaiPostTableViewCell"];
        [cell setUpWith:self.post];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }

    QiuBaiCommentTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"QiuBaiCommentTableViewCell"];
    [cell setupWith:[self.displayComments objectAtIndex:indexPath.row]];
    return cell;
}

#pragma mark - UITableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        QiuBaiPostTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"QiuBaiPostTableViewCell"];
        return [cell contentLabelHeightWithPost:self.post] + [cell staticHeight];
    }

    QiuBaiCommentTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"QiuBaiCommentTableViewCell"];
    return [cell heightWith:self.displayComments[indexPath.row]];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return self.commentTypeSwitch;
    }
    return nil;
}

#pragma mark - lazy init
- (QiuBaiTablikeSwitch*)commentTypeSwitch {
    if (!_commentTypeSwitch) {
        _commentTypeSwitch = [[QiuBaiTablikeSwitch alloc] init];
        _commentTypeSwitch.titleWhenOn = @"热门";
        _commentTypeSwitch.titleWhenOff = @"全部";
        [_commentTypeSwitch addTarget:self
                               action:@selector(commentTypeChanged:)
                     forControlEvents:UIControlEventValueChanged];
    }
    return _commentTypeSwitch;
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

#pragma mark - 
- (IBAction)commentTypeChanged:(id)sender {
    if (self.commentTypeSwitch.isOn) {
        self.displayComments = self.hotComments;
    } else {
        self.displayComments = self.allComments;
    }
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
}

- (NSArray*)allComments {
    return self.post.comments.allObjects;
}

- (NSArray*)hotComments {
    return self.post.comments.allObjects;
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
