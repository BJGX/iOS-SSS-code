//
//   YQPlayModel.h
   

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YQPlayModel : NSObject

@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *link;

@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *nickName;
@property (nonatomic, strong) NSString *songNum;
@property (nonatomic, strong) NSString *headIco;
@property (nonatomic, strong) NSString *cover;
@property (nonatomic, strong) NSString *brief;
@property (nonatomic, strong) NSString *truePlayNum;
@property (nonatomic, strong) NSString *album;
@property (nonatomic, strong) NSString *hasFavorite;
@property (nonatomic, strong) NSString *userFavorite;
@property (nonatomic, strong) NSString *playListFavorite;

@property (nonatomic, strong) NSString *hasLike;
@property (nonatomic, strong) NSString *cachePath;
@property (nonatomic, strong) NSString *voice;
@property (nonatomic, strong) NSString *lrc;

@property (nonatomic, strong) NSString *songerString;

@property (nonatomic, strong) NSString *superQuality;


@property (nonatomic, assign) NSInteger commentNum;
@property (nonatomic, assign) NSInteger state;
@property (nonatomic, assign) NSInteger totalSize;
@property (nonatomic, assign) NSInteger likeNum;

@property (nonatomic, assign) NSInteger playIndex;
///用户身份 0 普通用户 1 歌手 2 运营账号",
@property (nonatomic, assign) NSInteger identity;

@property (nonatomic, assign) BOOL showPriase;
@property (nonatomic, assign) BOOL completeDownload;
@property (nonatomic, assign) BOOL selecetedCell;

@property (nonatomic, strong) NSArray *singer;
@property (nonatomic, strong) NSArray *list;
@property (nonatomic, strong) NSArray *rows;

@end

NS_ASSUME_NONNULL_END
