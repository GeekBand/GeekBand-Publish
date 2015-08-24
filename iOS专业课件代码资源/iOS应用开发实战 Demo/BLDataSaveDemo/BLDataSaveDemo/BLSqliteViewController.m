//
//  BLSqliteViewController.m
//  BLDataSaveDemo
//
//  Created by duansong on 15-7-14.
//  Copyright 2015 __MyCompanyName__. All rights reserved.
//

#import "BLSqliteViewController.h"
#import "BLDetailViewController.h"
#import "BLPoemDB.h"

@implementation BLSqliteViewController

@synthesize createDBButton			= _createDBButton;
@synthesize addPoemToDBButton		= _addPoemToDBButton;
@synthesize queryPoemFromDBButton	= _queryPoemFromDBButton;
@synthesize modifyPoemInDBButton	= _modifyPoemInDBButton;
@synthesize deletePoemFromDBButton	= _deletePoemFromDBButton;

#pragma mark -
#pragma mark about view methods

- (void)viewDidLoad {
	[self initVariables];
	[self initComponents];
    [super viewDidLoad];
}


#pragma mark -
#pragma mark custom methods

- (void) initVariables {
	_poemArray = [[NSMutableArray alloc] initWithCapacity:5];
}

- (void) initComponents {
	self.navigationItem.title = @"SQLite";
	
	UIBarButtonItem *getAllFavoritesButton = [[UIBarButtonItem alloc] initWithTitle:@"收藏" 
																			  style:UIBarButtonItemStylePlain
																			 target:self 
																			 action:@selector(getFavoritesPoemsButtonClicked:)];
	self.navigationItem.rightBarButtonItem = getAllFavoritesButton;
	
	UIImage *ButtonBackgroundImageStateNormal = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"blueButton" ofType:@"png"]];
	UIImage *stretchableButtonBackgroundImageStateNormal = [ButtonBackgroundImageStateNormal stretchableImageWithLeftCapWidth:12 topCapHeight:20];
	
	UIImage *ButtonBackgroundImageStateHighlighted = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"whiteButton" ofType:@"png"]];
	UIImage *stretchableButtonBackgroundImageStateHighlighted = [ButtonBackgroundImageStateHighlighted stretchableImageWithLeftCapWidth:13 topCapHeight:20];
	
	[_createDBButton setBackgroundImage:stretchableButtonBackgroundImageStateNormal forState:UIControlStateNormal];
	[_createDBButton setBackgroundImage:stretchableButtonBackgroundImageStateHighlighted forState:UIControlStateHighlighted];
	
	[_addPoemToDBButton setBackgroundImage:stretchableButtonBackgroundImageStateNormal forState:UIControlStateNormal];
	[_addPoemToDBButton setBackgroundImage:stretchableButtonBackgroundImageStateHighlighted forState:UIControlStateHighlighted];
	[_addPoemToDBButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	
	[_queryPoemFromDBButton setBackgroundImage:stretchableButtonBackgroundImageStateNormal forState:UIControlStateNormal];
	[_queryPoemFromDBButton setBackgroundImage:stretchableButtonBackgroundImageStateHighlighted forState:UIControlStateHighlighted];
	[_queryPoemFromDBButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

	
	[_modifyPoemInDBButton setBackgroundImage:stretchableButtonBackgroundImageStateNormal forState:UIControlStateNormal];
	[_modifyPoemInDBButton setBackgroundImage:stretchableButtonBackgroundImageStateHighlighted forState:UIControlStateHighlighted];
	[_modifyPoemInDBButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

	
	[_deletePoemFromDBButton setBackgroundImage:stretchableButtonBackgroundImageStateNormal forState:UIControlStateNormal];
	[_deletePoemFromDBButton setBackgroundImage:stretchableButtonBackgroundImageStateHighlighted forState:UIControlStateHighlighted];
	[_deletePoemFromDBButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (NSMutableArray *)getPoems {
	NSMutableArray *poemArray = [[NSMutableArray alloc] initWithCapacity:5];
	
	BLPoem *poem1 = [[BLPoem alloc] init];
	poem1.poemId = 1;
	poem1.poemName = @"九月九日忆山东兄弟";
	poem1.poetName = @"王 维";
	poem1.poemContent = @"独在异乡为异客，\n每逢佳节倍思亲。\n遥知兄弟登高处，\n遍插茱萸少一人。";
	poem1.whetherFavorite = NO;
	[poemArray addObject:poem1];
	
	BLPoem *poem2 = [[BLPoem alloc] init];
	poem2.poemId = 2;
	poem2.poemName = @"闺 怨";
	poem2.poetName = @"王昌龄";
	poem2.poemContent = @"闺中少妇不知愁，\n春日凝妆上翠楼。\n 忽见陌头杨柳色，\n悔教夫婿觅封侯。";
	poem2.whetherFavorite = NO;
	[poemArray addObject:poem2];
	
	BLPoem *poem3 = [[BLPoem alloc] init];
	poem3.poemId = 3;
	poem3.poemName = @"送孟浩然之广陵";
	poem3.poetName = @"李 白";
	poem3.poemContent = @"故人西辞黄鹤楼，\n烟花三月下扬州。\n孤帆远影碧空尽，\n惟见长江天际流。";
	poem3.whetherFavorite = NO;
	[poemArray addObject:poem3];
	
	BLPoem *poem4 = [[BLPoem alloc] init];
	poem4.poemId = 4;
	poem4.poemName = @"江南逢李龟年";
	poem4.poetName = @"杜 甫";
	poem4.poemContent = @"歧王宅里寻常见，\n崔九堂前几度闻。\n正是江南好风景，\n落花时节又逢君。";
	poem4.whetherFavorite = NO;
	[poemArray addObject:poem4];
	
	BLPoem *poem5 = [[BLPoem alloc] init];
	poem5.poemId = 5;
	poem5.poemName = @"下 江 陵";
	poem5.poetName = @"李 白";
	poem5.poemContent = @"朝辞白帝彩云间，\n千里江陵一日还。\n两岸猿声啼不住，\n轻舟已过万重山。";
	poem5.whetherFavorite = NO;
	[poemArray addObject:poem5];
	
	return poemArray;
}


#pragma mark -
#pragma mark custom event methods

- (IBAction) createDBButtonClicked:(id)sender {
	BLPoemDB *poemDB = [[BLPoemDB alloc] init];
	[poemDB createPoemTable];
}

- (IBAction) addPoemToDBButtonClicked:(id)sender {
	BLPoemDB *poemDB = [[BLPoemDB alloc] init];
	NSMutableArray *poemArray = [self getPoems];
	for (BLPoem *poem in poemArray) {
		[poemDB addPoem:poem];
	}
}

- (IBAction) queryPoemFromDBButtonClicked:(id)sender {
	BLPoemDB *poemDB = [[BLPoemDB alloc] init];
	NSMutableArray *poemArray = [poemDB getAllPoems];
	[_poemArray removeAllObjects];
	[_poemArray addObjectsFromArray:poemArray];
	[_poemTableView reloadData];
}

- (IBAction) modifyPoemInDBButtonClicked:(id)sender {
	
}

- (IBAction) deletePoemFromDBButtonClicked:(id)sender {
	_poemTableView.editing = !_poemTableView.editing;
}

- (void) getFavoritesPoemsButtonClicked:(id)sender {
	BLPoemDB *poemDB = [[BLPoemDB alloc] init];
	NSMutableArray *favoritePoems = [poemDB getFavoritesPoems];
	[_poemArray removeAllObjects];
	[_poemArray addObjectsFromArray:favoritePoems];
	[_poemTableView reloadData];
}


#pragma mark -
#pragma mark UITableViewDelegate and UITableViewDataSource methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 40;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [_poemArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"CellIdentifier";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	
	if ([_poemArray count] > indexPath.row) {
		BLPoem *poem = [_poemArray objectAtIndex:indexPath.row];
		cell.textLabel.text = poem.poemName;
	}
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([_poemArray count] > indexPath.row) {
		BLPoem *poem = [_poemArray objectAtIndex:indexPath.row];
		BLDetailViewController *poemDetailViewController = [[BLDetailViewController alloc] init];
		poemDetailViewController.poem = poem;
		[self.navigationController pushViewController:poemDetailViewController animated:YES];
	}
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle 
forRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([_poemArray count] > indexPath.row) {
		BLPoem *poem = [_poemArray objectAtIndex:indexPath.row];
		BLPoemDB *poemDB = [[BLPoemDB alloc] init];
		BOOL resutl = [poemDB deletePoemWithPoemId:poem.poemId];
		if (resutl) {
			[_poemArray removeObjectAtIndex:indexPath.row];
			[_poemTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationTop];
		}
	}
}


#pragma mark -
#pragma mark memory management methods

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
	_poemArray					= nil;
	
	self.createDBButton			= nil;
	self.addPoemToDBButton		= nil;
	self.queryPoemFromDBButton	= nil;
	self.modifyPoemInDBButton	= nil;
	self.deletePoemFromDBButton = nil;	
}


@end
