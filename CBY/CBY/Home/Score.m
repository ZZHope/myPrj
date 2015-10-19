//
//  Score.m
//  51CBY
//
//  Created by SJB on 14/12/23.
//  Copyright (c) 2014年 SJB. All rights reserved.
//

#import "Score.h"

@implementation Score


-(int)scoreValue
{
    int totalScore = 0;
    
   totalScore =  [self yearScore]+[self jurneyScore]+[self careScore]+[self unFrozenScore]+[self powerScore]+[self tireScore]+[self lineScore]+[self rainScore]+[self enginScore]+[self repairScore];
    

    return 100-totalScore;
    
}


-(int) yearScore
{
    int score = 0;
    if ([self.age intValue]> 10) {
        score = ([self.age intValue]-10)*2;
    }else{
        score = 0;
    }
    

    return score;
}

-(int) jurneyScore
{
    int score = 0;
    if ([self.jurney intValue]> 30) {
        score = (([self.jurney intValue]-30)/3)*2;
    }else{
        score = 0;
    }
 
 
    return score;
}

-(int) careScore
{
    int score = 0;
    if (([self.care intValue]-6)>= 1 && ([self.care intValue]-6) < 2) {
        score = 10;
    }else if(([self.care intValue]-6)>= 2&& ([self.care intValue]-6) < 3)
    {
        score = 20;
    }else if (([self.care intValue]-6) >= 3)
    {
        score = 30;
    }


    return score;
}

-(int) unFrozenScore
{
    int score = 0;
    if ([self.unFrozen intValue]> 12) {
        score = 5;
    }else{
        score = 0;
    }


    return score;
}

-(int) powerScore
{
    int score = 0;
    if ([self.changePower intValue]> 3) {
        score = 3;
    }else{
        score = 0;
    }

    return score;
}

-(int) tireScore
{
    int score = 0;
    if (([self.tire intValue]-6)>= 1&&([self.tire intValue]-6)<=3) {
        score = 1;
    }else if(([self.tire intValue]-6)>=4 &&([self.tire intValue]-6)<=5){
        score = 2;
    }else if(([self.tire intValue]-6)>5 &&([self.tire intValue]-6)<=6){
        score = 4;
    }else if(([self.tire intValue]-6)>6 ){
        score = 8;
    }


    return score;
    
}

-(int) lineScore
{
    //self.line = !self.line;
    int score = 0;
    if (self.line) {
        score = 0;
    }else{
        score = 3;
    }

    return score;
}


-(int) rainScore
{
    int score = 0;
    if (([self.rain intValue]-6)> 0) {
        score = 2;
    }else{
        score = 0;
    }
    
 

    return score;
}

-(int) enginScore
{
    int score = 0;
    if (([self.engin intValue]-6)> 0) {
        score = 2;
    }else{
        score = 0;
    }
  
   
    return score;
}

-(int) repairScore
{
   // self.hugeRepaire = !self.hugeRepaire;
    int score = 0;
    if (self.hugeRepaire) {
        score = 30;
    }else{
        score = 0;
    }
  
    
    return score;
}

@end
