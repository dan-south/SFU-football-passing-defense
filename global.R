library(tidyr)
library(dplyr)
library(rsconnect)

# data frames from each game and overall
# create df function #
createdf <- function(csv){
  df <- read.csv(csv, header=TRUE)
  df %>% mutate(Yds = Comp*(Dist+AfterCatch)) -> df
  return(df)
}
ovrdf <- createdf("ovr.csv")
wk3df <- createdf("wk3.csv")
wk4df <- createdf("wk4.csv")


# choose game function # 
selectdf <- function(wk){
  if(wk == "ovr"){
    df <- ovrdf
  }else if(wk == "wk3"){
    df <- wk3df
  }else if(wk == "wk4"){
    df <- wk4df
  }else{
    df <- ovrdf
  }
  return(df)
}


# summarize all directions # 
combineDirStats <- function(df){
  ovrSmry <- summarizePassD(df)
  df %>% filter(Dir=='L') %>% summarizePassD() -> LSmry 
  df %>% filter(Dir=='C') %>% summarizePassD() -> CSmry 
  df %>% filter(Dir=='R') %>% summarizePassD() -> RSmry 
  fullSmry <- cbind(ovrSmry,LSmry,CSmry,RSmry)
  fullSmry <- as.data.frame(fullSmry)
  names(fullSmry)[1] <- "OVR"
  names(fullSmry)[2] <- "Pass Left"
  names(fullSmry)[3] <- "Pass Center"
  names(fullSmry)[4] <- "Pass Right"
  
  return(fullSmry)
}

### summary function ###
summarizePassD <- function(df){
  compPerc <- sum(df[,2])/length(df[,2])
  attempts <- length(df[,2])
  completions <- sum(df[,2])
  yds <- sum(df[,11])
  TDs <- sum(df[,5])
  Ints <- sum(df[,7])
  YAC <- sum(df[,4])
  gmsmmry <- rbind(compPerc,attempts,completions,yds,TDs,Ints,YAC)
  return(gmsmmry)
}
