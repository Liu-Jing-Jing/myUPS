

// .h
#define single_interface(class)  + (class *)shared##class;

// .m
// \ 代表下一行也属于宏
// ## 是分隔符
#define single_implementation(class) \
static class *_instance; \
 \
+ (class *)shared##class \
{ \
    if (_instance == nil) { \
        _instance = [[self alloc] init]; \
    } \
    return _instance; \
} \
 \
+ (id)allocWithZone:(NSZone *)zone \
{ \
    static dispatch_once_t onceToken; \
    dispatch_once(&onceToken, ^{ \
        _instance = [super allocWithZone:zone]; \
    }); \
    return _instance; \
}

// 自定义Cell的代码块
#define customCell_interface + (instancetype)cellforTableView:(UITableView *)tableView;
#define customCell_implementation(class) \
+ (instancetype)cellforTableView:(UITableView *)tableView \
{ \
static NSString *ID = @#class; \
    class * cell = [tableView dequeueReusableCellWithIdentifier:ID]; \
    if (!cell) \
    { \
        [tableView registerNib:[UINib nibWithNibName:ID bundle:nil] forCellReuseIdentifier:ID]; \
        cell = [tableView dequeueReusableCellWithIdentifier:ID]; \
    } \
    return cell; \
}

// 改变分割线的长度
#define tableviewGroupNoSeparetorLine__implementation \
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath \
{ \
    cell.layoutMargins = UIEdgeInsetsZero; \
    cell.separatorInset = UIEdgeInsetsZero; \
    cell.preservesSuperviewLayoutMargins = NO; \
} \
 \
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section \
{ \
    return (0.1); \
} \
 \
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section \
{ \
    return 0.1; \
}

#define badgeMarco \
- (int)getH \
{ return 2;}


// 兼容iOS 11的
#define  adjustsScrollViewInsets_NO(scrollView,vc)\
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
if ([UIScrollView instancesRespondToSelector:NSSelectorFromString(@"setContentInsetAdjustmentBehavior:")]) {\
[scrollView   performSelector:NSSelectorFromString(@"setContentInsetAdjustmentBehavior:") withObject:@(2)];\
} else {\
vc.automaticallyAdjustsScrollViewInsets = NO;\
}\
_Pragma("clang diagnostic pop") \
} while (0)
