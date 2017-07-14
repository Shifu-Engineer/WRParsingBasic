/**
 * Copyright (c) 2017, Ray Wang
 * All rights reserved
 * Author: RayWang
 */

#import "WRItem.h"

@interface WRItem ()

@end

@implementation WRItem

- (instancetype)initWithRuleStr:(NSString *)ruleStr
                    dotPosition:(NSInteger)dotPosition
                andItemPosition:(NSInteger)itemPosition {
  
  if (self = [super initWithRuleStr:ruleStr]) {
    _dotPos = dotPosition;
    _itemPos = itemPosition;
  }
  return self;
}

+ (instancetype)itemWithRuleStr:(NSString *)ruleStr
                    dotPosition:(NSInteger)dotPosition
                andItemPosition:(NSInteger)itemPosition {
  WRItem *item = [[WRItem alloc] initWithRuleStr:ruleStr
                                     dotPosition:dotPosition
                                 andItemPosition:itemPosition];
  return item;
}

- (instancetype)initWithRule:(WRRule *)rule
                 dotPosition:(NSInteger)dotPosition
             andItemPosition:(NSInteger)itemPosition {
  if (self = [super initWithRule:rule]) {
    _dotPos = dotPosition;
    _itemPos = itemPosition;
    self.ruleIndex = rule.ruleIndex;
  }
  return self;
}

+ (instancetype)itemWithRule:(WRRule *)rule
                 dotPosition:(NSInteger)dotPosition
             andItemPosition:(NSInteger)itemPosition {
  return [[WRItem alloc] initWithRule:rule
                          dotPosition:dotPosition
                      andItemPosition:itemPosition];
}

- (instancetype)initWithItem:(WRItem *)item
             andItemPosition:(NSInteger)itemPosition {
  if (self = [super initWithRule:item]) {
    _dotPos = item.dotPos;
    _itemPos = itemPosition;
    self.ruleIndex = item.ruleIndex;
  }
  return self;
}

+ (instancetype)itemWithItem:(WRItem *)item
             andItemPosition:(NSInteger)position {
  return [[WRItem alloc] initWithItem:item
                      andItemPosition:position];
}

- (NSString *)description {
  return [NSString stringWithFormat:@"%@ @%ld",
          self.dotedRule,
          self.itemPos];
}

- (NSString *)descriptionForReductions {
  if (self.reductionList.count == 0) {
    return nil;
  }
  NSMutableString *string = [NSMutableString string];
  for (WRPair *pair in self.reductionList) {
    [string appendFormat:@"%@; ",
     pair];
  }
  [string appendString:@"\n"];
  return string;
}

- (NSString *)descriptionForPredecessors {
  if (self.predecessorList.count == 0) {
    return nil;
  }
  NSMutableString *string = [NSMutableString string];
  for (WRPair *pair in self.predecessorList) {
    [string appendFormat:@"%@; ",
     pair];
  }
  [string appendString:@"\n"];
  return string;
}

- (NSUInteger)hash {
  return self.description.hash;
}

- (BOOL)isComplete {
  return self.rightTokens.count <= self.dotPos;
}

- (NSString *)nextAskingToken {
  if (self.isComplete) {
    return nil;
  } else {
    return self.rightTokens[_dotPos];
  }
}

- (NSString *)justCompletedToken {
  if (self.dotPos >= 1 && self.dotPos <= self.rightTokens.count) {
    return self.rightTokens[self.dotPos - 1];
  } else {
    return nil;
  }
}

- (NSString *)currentDotedRule {
  NSMutableString *mutStr = [NSMutableString stringWithString:self.leftToken];
  [mutStr appendString:@" ->"];
  
  NSInteger i = 0;
  for(NSString *token in self.rightTokens){
    if(i == _dotPos){
      [mutStr appendFormat:@" ·%@",token];
    } else{
      [mutStr appendFormat:@" %@",token];
    }
    i++;
  }
  
  if (self.rightTokens.count == _dotPos) {
    [mutStr appendString:@"·"];
  }
  return mutStr;
}

- (void)setDotPos:(NSInteger)dotPos {
  _dotPos = dotPos;
  _dotedRule = self.currentDotedRule;
}

- (NSString *)dotedRule {
  if (nil == _dotedRule) {
    _dotedRule = self.currentDotedRule;
  }
  return _dotedRule;
}

- (NSMutableDictionary <NSString *, WRPair *> *)predecessorList {
  if (nil == _predecessorList) {
    _predecessorList = [NSMutableDictionary dictionary];
  }
  return _predecessorList;
}

- (NSMutableDictionary <NSString *, WRPair *> *)reductionList {
  if (nil == _reductionList) {
    _reductionList = [NSMutableDictionary dictionary];
  }
  return _reductionList;
}
@end