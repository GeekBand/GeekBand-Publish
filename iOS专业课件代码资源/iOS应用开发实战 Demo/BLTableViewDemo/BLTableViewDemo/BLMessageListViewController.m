//
//  ViewController.m
//  BLTableViewDemo
//
//  Created by derek on 7/10/15.
//  Copyright (c) 2015 derek. All rights reserved.
//

#import "BLMessageListViewController.h"
#import "BLUserSpaceViewController.h"
#import "BLMessage.h"
#import "BLCellButton.h"

@implementation BLMessageListViewController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _messageArray = [[NSMutableArray alloc] initWithCapacity:5];
    [self createMessageData];
    
    self.navigationItem.title = @"信息列表";
    
    UIBarButtonItem *editButton
    = [[UIBarButtonItem alloc] initWithTitle:@"编辑"
                                       style:UIBarButtonItemStylePlain
                                      target:self
                                      action:@selector(editButtonClicked:)];
    self.navigationItem.rightBarButtonItem = editButton;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}


#pragma mark - custom event methods

- (void)editButtonClicked:(UIBarButtonItem *)editButton {
    _tableView.editing = !_tableView.editing;
    
    if (_tableView.editing) {
        [editButton setTitle:@"完成"];
    }else {
        [editButton setTitle:@"编辑"];
    }
}


#pragma mark - custom methods

- (void)createMessageData {
    [_messageArray addObject:[BLMessage messageWithSender:[BLUser userWithName:@"Steve Jobs"
                                                                 headImagePath:[[NSBundle mainBundle]
                                                                                pathForResource:@"headImage1"
                                                                                ofType:@"png"]
                                                                 lifePhotoPath:[[NSBundle mainBundle]
                                                                                pathForResource:@"jobs"
                                                                                ofType:@"png"]]
                                                     text:@"乔布斯是改变世界的天才，他凭敏锐的触觉和过人的智慧，勇于变革，不断创新，引领全球资讯科技和电子产品的潮流，把电脑和电子产品变得简约化、平民化，让曾经是昂贵稀罕的电子产品变为现代人生活的一部分。"
                                                 sendDate:[NSDate date]]];
    
    [_messageArray addObject:[BLMessage messageWithSender:[BLUser userWithName:@"李小龙"
                                                                 headImagePath:[[NSBundle mainBundle]
                                                                                pathForResource:@"headImage2"
                                                                                ofType:@"png"]
                                                                 lifePhotoPath:[[NSBundle mainBundle]
                                                                                pathForResource:@"li"
                                                                                ofType:@"png"]]
                                                     text:@"李小龙，原名李振藩，乳名细凤，为美籍华人，祖籍中国广东省佛山市顺德区均安镇，身高173厘米，体重64公斤。他是一位武术技击家、武术哲学家、全球范围内具有影响力的著名华人武打电影演员、世界武道改革先驱者，UFC起源者，MMA之父，截拳道武道哲学的创立人。"
                                                 sendDate:[NSDate date]]];
    
    [_messageArray addObject:[BLMessage messageWithSender:[BLUser userWithName:@"成龙"
                                                                 headImagePath:[[NSBundle mainBundle]
                                                                                pathForResource:@"headImage3"
                                                                                ofType:@"png"]
                                                                 lifePhotoPath:[[NSBundle mainBundle]
                                                                                pathForResource:@"cheng"
                                                                                ofType:@"png"]]
                                                     text:@"成龙，1954年4月7日生于香港太平山，国家一级演员，大中华区影坛巨星和国际功夫电影巨星，在华人世界享有极高声望与影响。他与周星驰、周润发并称“双周一成”，意为香港电影的票房保证。成龙以功夫片著称，曾经多次打破香港电影票房纪录，目前其主演的电影全球总票房已经超过100亿元，为华人演员之首。成龙的成名作是功夫喜剧《醉拳》，1994年由他主演的《红番区》在美国公映后反响强烈，使其成功打入美国好莱坞，而接下的《尖峰时刻》系列电影亦获得极高的票房，并奠定其国际电影巨星的地位。"
                                                 sendDate:[NSDate date]]];
    
    
    [_messageArray addObject:[BLMessage messageWithSender:[BLUser userWithName:@"赵本山"
                                                                 headImagePath:[[NSBundle mainBundle]
                                                                                pathForResource:@"headImage4"
                                                                                ofType:@"png"]
                                                                 lifePhotoPath:[[NSBundle mainBundle]
                                                                                pathForResource:@"zhao"
                                                                                ofType:@"png"]]
                                                     text:@"赵本山，男，生于1957年10月2日，籍贯是辽宁省铁岭市开原县莲花乡莲花村石嘴沟。著名表演艺术家、国家一级演员、“德艺双馨”艺术家、国家级非物质文化遗产项目代表性传承人。全国青联委员、全国总工会代表、中国曲艺家协会理事、辽宁省曲艺家协会副主席、第十届全国人大代表、辽宁省政协委员、辽宁大学本山艺术学院院长、本山传媒集团董事长。赵本山在央视春晚上享有极高声望，深受人民喜爱，连续10余年蝉联春晚“小品王”。创立本山传媒集团，演出、影视制作、电视栏目和艺术教育等方面大有作为，佳作频出，均创下骄人业绩，广受好评。"
                                                 sendDate:[NSDate date]]];
    
    
    [_messageArray addObject:[BLMessage messageWithSender:[BLUser userWithName:@"甄子丹"
                                                                 headImagePath:[[NSBundle mainBundle]
                                                                                pathForResource:@"headImage5"
                                                                                ofType:@"png"]
                                                                 lifePhotoPath:[[NSBundle mainBundle]
                                                                                pathForResource:@"zhen"
                                                                                ofType:@"png"]]
                                                     text:@"甄子丹（Donnie Yen，1963年7月27日－），武术家、演员、导演。参与多部西方电影的演出与幕后，与成龙、李连杰同为国际知名的华人武打演员，还担任香港李小龙协会理事、世界明星厨师联合会副主席。2003年5月与年龄相距19岁的多伦多三料华埠小姐冠军汪诗诗结为连理，育有一子一女。"
                                                 sendDate:[NSDate date]]];
    
}


#pragma mark - UITableViewDelegate and UITableViewDataSource methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_messageArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([_messageArray count] > indexPath.row) {
        BLMessage *message = (BLMessage *)[_messageArray objectAtIndex:indexPath.row];
        return [BLCustomCell calculateCellHeightWithMessage:message];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CellIdentifier";
    BLCustomCell *cell = (BLCustomCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[BLCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        cell.delegate = self;
    }
    
    [cell cleanComponents];
    
    if ([_messageArray count] > indexPath.row) {
        BLMessage *message = [_messageArray objectAtIndex:indexPath.row];
        [cell setComponentsWithMessage:message indexPath:indexPath];
        [cell setHeadImage:[UIImage imageWithContentsOfFile:message.sender.headImagePath]];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return UITableViewCellEditingStyleInsert;
    }
    return UITableViewCellEditingStyleDelete;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0 || indexPath.row == 1) {
        return YES;
    }
    return NO;
}

- (NSString *)tableView:(UITableView *)tableView
titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除此行";
}

-(void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleInsert) {
        BLUser *user = [BLUser userWithName:@"12345" headImagePath:nil lifePhotoPath:nil];
        BLMessage *message = [BLMessage messageWithSender:user text:@"1234567890-esrdfghjkl;" sendDate:[NSDate date]];
        [_messageArray insertObject:message atIndex:indexPath.row];
        [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                         withRowAnimation:UITableViewRowAnimationLeft];
    }else if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_messageArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
    }
//        [tableView reloadData];
}


#pragma mark - BLCustomDelegate methods

- (void)headButtonClicked:(BLCellButton *)headButton {
    if ([_messageArray count] > headButton.cellRow) {
        BLMessage *message = (BLMessage *)[_messageArray objectAtIndex:headButton.cellRow];
        BLUserSpaceViewController *userSpaceViewController= [[BLUserSpaceViewController alloc] init];
        userSpaceViewController.message = message;
        [self.navigationController pushViewController:userSpaceViewController animated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
