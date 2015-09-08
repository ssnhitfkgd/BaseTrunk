//
//  WYSettingViewController.m
//  StealTrunk
//
//  Created by wangyong on 13-7-19.
//
//

#import "WYSettingViewController.h"
#import "iRate.h"
#import "WYUserInfoDto.h"
#import "SVWebViewController.h"

#define UISwitchWidth  50
#define UISwitchHeight 20

@implementation WYSettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = (@"设置");
//        self.hidesBottomBarWhenPushed = YES;
    
        
    }
    return self;
}

- (void) viewDidLoad {
    [super viewDidLoad];
    
    [self initTableView];
}


- (void)initTableView
{
    self.tableView.backgroundColor = [UIColor colorFromHexString:@"#f9f9f9"];
    __weak typeof(self) block_self = self;
    
	[self addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
        static NSString *reuseIdentifier = @"cell";
        
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.reuseIdentifier = reuseIdentifier;
            staticContentCell.cellHeight = 60;
            staticContentCell.cellStyle = UITableViewCellStyleValue1;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
			cell.textLabel.text = (@"text");
		} ];
    }];
    
    [self addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
        static NSString *reuseIdentifier = @"cell1";
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.cellHeight = 60;
            staticContentCell.reuseIdentifier = reuseIdentifier;
            staticContentCell.cellStyle = UITableViewCellStyleValue1;
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            [cell.textLabel setText: (@"text")];
            [cell.textLabel setBackgroundColor:[UIColor clearColor]];
            cell.detailTextLabel.text = @"detail";

        } whenSelected:^(NSIndexPath *indexPath) {
            
        }];
    }];

    
    [self addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
        section.title = (@"section header");
        NSString *reuseIdentifier = @"push";
        
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.reuseIdentifier = reuseIdentifier;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.text = (@"text");
            
            UISwitch *respond_switch = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, UISwitchWidth, UISwitchHeight)];
            respond_switch.tag = 9;
            [respond_switch setOn:YES animated:NO];
//            [respond_switch addTarget:block_self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = respond_switch;
        } whenSelected:^(NSIndexPath *indexPath) {
            
        }];
        
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.reuseIdentifier = reuseIdentifier;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.text = (@"text");
            
            UISwitch *respond_switch = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, UISwitchWidth, UISwitchHeight)];
            respond_switch.tag = 2;
            [respond_switch setOn:YES animated:NO];
//            [respond_switch addTarget:block_self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = respond_switch;
        } whenSelected:^(NSIndexPath *indexPath) {
            
        }];
        
    }];
    
    [self addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
        //section.title = NSLocalizedString(@"关于", nil);
        NSString *reuseIdentifier = @"about";
        
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            
            staticContentCell.cellStyle = UITableViewCellStyleDefault;
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            cell.textLabel.text = (@"text");
            [cell.textLabel setBackgroundColor:[UIColor clearColor]];
            cell.detailTextLabel.text = @"";
        } whenSelected:^(NSIndexPath *indexPath) {
            
            SVWebViewController *webVC = [[SVWebViewController alloc] initWithAddress:@"http://www.baidu.com"];
            [block_self.navigationController pushViewController:webVC animated:YES];
            webVC.title = (@"功能介绍");
            webVC = nil;
            
        }];
        
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.tableViewCellSubclass = [UITableViewCell class];
            staticContentCell.reuseIdentifier = reuseIdentifier;
            staticContentCell.cellStyle = UITableViewCellStyleDefault;
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            [cell.textLabel setText: (@"text")];
            [cell.textLabel setBackgroundColor:[UIColor clearColor]];
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
            [imageView setImage:[[UIImage imageNamed:@"8"] imageWithColor:[UIColor redColor]]];
            [cell setAccessoryView:imageView];
        } whenSelected:^(NSIndexPath *indexPath) {
//            [[iRate sharedInstance] openRatingsPageInAppStore];
        }];
        
        
    }];

    
}

@end



