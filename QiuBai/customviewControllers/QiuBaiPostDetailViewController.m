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
#import "EditCommentView.h"
#import "ModelStore.h"

@interface QiuBaiPostDetailViewController ()<UITableViewDelegate, UITableViewDataSource, EditCommentViewDelegate>
@property (strong, nonatomic)   IBOutlet    QiuBaiTablikeSwitch* commentTypeSwitch;
@property (strong, nonatomic)   NSArray*    allComments;
@property (strong, nonatomic)   NSArray*    hotComments;

@property (strong, nonatomic)   NSArray*    displayComments;
@property (nonatomic)           CGFloat     editCommentViewHeight;
@property (strong, nonatomic)   IBOutlet    EditCommentView*    editCommentView;
@property (strong, nonatomic)   IBOutlet    UITableView*    tableView;
@end

@implementation QiuBaiPostDetailViewController

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super init];
    if (self) {
        self.editCommentViewHeight = 44.0;
        self.view = [[UIScrollView alloc] initWithFrame:frame];
        ((UIScrollView*)self.view).contentSize = frame.size;

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardDidShown:)
                                                     name:UIKeyboardDidShowNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardDidHide:)
                                                     name:UIKeyboardDidHideNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardDidShown:)
                                                     name:UIKeyboardDidChangeFrameNotification
                                                    object:nil];

        CGRect editViewFrame = CGRectMake(0,
                                          frame.size.height - self.editCommentViewHeight,
                                          frame.size.width,
                                          self.editCommentViewHeight);
        self.editCommentView = [[EditCommentView alloc] initWithFrame:editViewFrame];
        self.editCommentView.backgroundColor = [UIColor whiteColor];
        self.editCommentView.delegate = self;
        [self.view addSubview:self.editCommentView];
        frame.origin.x = frame.origin.y = 0;
        frame.size.height = frame.size.height - self.editCommentViewHeight;
        self.tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
        self.tableView.tableHeaderView = nil;
        self.automaticallyAdjustsScrollViewInsets = NO;
        [self.tableView registerNib:[UINib nibWithNibName:@"QiuBaiPostTableViewCell" bundle:nil]
             forCellReuseIdentifier:@"QiuBaiPostTableViewCell"];
        [self.tableView registerNib:[UINib nibWithNibName:@"QiuBaiCommentTableViewCell" bundle:nil]
             forCellReuseIdentifier:@"QiuBaiCommentTableViewCell"];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;

        [self.view addSubview:self.tableView];
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
        [cell.addCommentButton addTarget:self
                                  action:@selector(tapAddCommentButton:)
                        forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }

    QiuBaiCommentTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"QiuBaiCommentTableViewCell"];
    [cell setupWith:[self.displayComments objectAtIndex:indexPath.row]];
    cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
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
    if (!self.displayComments || self.displayComments.count==0) {
        return 1;
    }
    return 2;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return self.commentTypeSwitch;
    }
    return nil;
}

#pragma mark - Edit Comment View delegate
- (void)didFinishedCommentEditing:(UITextView *)textView {
    [textView resignFirstResponder];

    NSString* commentContent = textView.text;
    NSIndexPath* newIndexPath = nil;
    if (commentContent && (![commentContent isEqualToString:@""])) {

        textView.text = nil;
        QiuBaiComment* newComment = [[ModelStore sharedStore] newCommentWithContent:commentContent];
        [[ModelStore sharedStore] addComment:newComment toPost:self.post];
        [self.tableView reloadData];
        newIndexPath = [NSIndexPath indexPathForRow:self.displayComments.count-1 inSection:1];
    }
    [UIView animateWithDuration:0.3
                     animations:^{
                         [self.tableView scrollToRowAtIndexPath:newIndexPath
                                               atScrollPosition:UITableViewScrollPositionBottom animated:YES];

                         UIScrollView* scrollView = (UIScrollView*)self.view;
                         scrollView.contentInset = UIEdgeInsetsZero;
                         scrollView.scrollIndicatorInsets = UIEdgeInsetsZero;
                     }];
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


//#pragma mark - UITextView delegate
//- (void)textViewDidBeginEditing:(UITextView *)textView {
//    CGRect frame = self.editCommentView.frame;
////    frame.origin.y -= 432;
//    [(UIScrollView*)self.view scrollRectToVisible:frame animated:YES];
//}
- (void)keyboardDidShown:(NSNotification*)aNotification {
    
    NSDictionary* info = [aNotification userInfo];
    CGRect kbRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];

    if (! CGRectContainsPoint(self.view.frame, kbRect.origin)) {
        return;
    }
    CGSize kbSize = kbRect.size;


    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    ((UIScrollView*)self.view).contentInset = contentInsets;
    ((UIScrollView*)self.view).scrollIndicatorInsets = contentInsets;

    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your app might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    UIView* activeField = self.editCommentView;
    if (!CGRectContainsPoint(aRect, activeField.frame.origin) ) {
        [(UIScrollView*)self.view scrollRectToVisible:activeField.frame animated:YES];
    }

    if (!self.editCommentView.observationInfo) {
        [self.editCommentView addObserver:self
                               forKeyPath:@"frame"
                                  options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                                  context:NULL];
    }
}

- (void)keyboardDidHide:(NSNotification*)aNotification {
    @try {
        [self.editCommentView removeObserver:self forKeyPath:@"frame"];
    } @catch (NSException *exception) {
        // removed observer before
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *,id> *)change
                       context:(void *)context {
    if ([keyPath isEqualToString:@"frame"]) {
        NSValue* frameObject = change[@"new"];
        NSValue* oldFrame = change[@"old"];
        [(UIScrollView*)self.view scrollRectToVisible:frameObject.CGRectValue animated:YES];
        CGRect newTableViewFrame = self.tableView.frame;
        newTableViewFrame.size.height = oldFrame.CGRectValue.size.height + self.tableView.frame.size.height - frameObject.CGRectValue.size.height;

        [UIView animateWithDuration:0.3
                         animations:^{
                             self.tableView.frame = newTableViewFrame;
                         }];
    }
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
    if (self.displayComments.count) {
//        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView reloadData];
    }
}

- (NSArray*)allComments {
    return self.post.comments;
}

- (NSArray*)hotComments {
    return self.post.comments;
}

- (IBAction)tapAddCommentButton:(id)sender {
    [self.editCommentView beginEditComment];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    @try {
        [self.editCommentView removeObserver:self forKeyPath:@"frame"];
    } @catch (NSException *exception) {
        // removed observer before
        NSLog(@"it is not registered as an observer!");
    } 
}

@end
