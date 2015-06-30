context("DecodeAttachment")

test_that("String versions of Attachments correctly converted to data frames", {

# core
  
   a.string<-"1919 2142099 5040  -420 0103   310Nw_Zealnd   1355 26      10004      100   89                              "
   a.df<-data.frame(1919,2,14,20.99,50.4,-4.2,0,0,0,3,NA,NA,3,10,'Nw_Zealnd',NA,NA,135,
                   5,2.6,NA,NA,NA,NA,1000.4,NA,NA,NA,10,NA,8.9,NA,NA,NA,NA,NA,NA,NA,NA,
                   NA,NA,NA,NA,NA,NA,NA,NA,NA,
                   stringsAsFactors = FALSE)
   w<-which(is.na(a.df[1,]))
   a.df[w]<-as.numeric(a.df[w])
   colnames(a.df)<-c('YR','MO','DY','HR','LAT','LON','IM','ATTC','TI','LI','DS','VS','NID',
                    'II','ID','C1','DI','D','WI','W','VI','VV','WW','W1','SLP','A','PPP',
                    'IT','AT','WBTI','WBT','DPTI','DPT','SI','SST','N','NH','CL','HI','H',
                    'CM','CH','WD','WP','WH','SD','SP','SH')
   a.df$C1<-as.character(a.df$C1)
   expect_equal(a.df,DecodeAttachment(a.string,'C0'))

# icoads
   
   a.string<-" 138 9701 69 5 0 1                  FF11FF71AAAAAAAAAAAA     "
   a.df<-data.frame(NA,138,9,701,69,5,0,NA,1,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,
                    NA,NA,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,NA,NA,NA,
                   stringsAsFactors = FALSE)
   w<-which(is.na(a.df[1,]))
   a.df[w]<-as.numeric(a.df[w])
   colnames(a.df)<-c('BSI','B10','B1','DCK','SID','PT','DUPS','DUPC','TC','PB','WX','SX',
                     'C2','SQZ','SQA','AQZ','AQA','UQZ','UQA','VQZ','VQA','PQZ','PQA','DQZ',
                     'DQA','ND','SF','AF','UF','VF','PF','RF','ZNC','WNC','BNC','XNC','YNC',
                     'PNC','ANC','GNC','DNC','SNC','CNC','ENC','FNC','TNC','QCE','LZ','QCZ')
   a.df$BSI<-as.character(a.df$BSI)
   expect_equal(a.df,DecodeAttachment(a.string,'C1'))
   
# supd

   a.string<-"1919/02/12:12       50       47                 b    30.29                 2        E 4caf88f0cadfd34197023862"
   a.df<-data.frame(a.string,stringsAsFactors = FALSE)
   colnames(a.df)<-c('SUPD')
   expect_equal(a.df,DecodeAttachment(a.string,'C99'))
  

})

context("UnpackRecord")

test_that("String versions of Records correctly split into attachments and converted to data frames", {

   a.string<-"1919 2141700 5040  -420 0103   310Nw_Zealnd    905 26      10021      100   94                              99 0 1919/02/14:20       50       49                 m    29.67                 2        E 4caf88f0cadfd34197023864"
   a.df<-data.frame(1919,2,14,17,50.4,-4.2,0,0,0,3,NA,NA,3,10,'Nw_Zealnd',NA,NA,90,
                   5,2.6,NA,NA,NA,NA,1002.1,NA,NA,NA,10,NA,9.4,NA,NA,NA,NA,NA,NA,NA,NA,
                   NA,NA,NA,NA,NA,NA,NA,NA,NA,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,
                   FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,TRUE," 1919/02/14:20       50       49                 m    29.67                 2        E 4caf88f0cadfd34197023864",
                   stringsAsFactors = FALSE)
   w<-which(is.na(a.df[1,]))
   a.df[w]<-as.numeric(a.df[w])
   colnames(a.df)<-c('YR','MO','DY','HR','LAT','LON','IM','ATTC','TI','LI','DS','VS','NID',
                    'II','ID','C1','DI','D','WI','W','VI','VV','WW','W1','SLP','A','PPP',
                    'IT','AT','WBTI','WBT','DPTI','DPT','SI','SST','N','NH','CL','HI','H',
                    'CM','CH','WD','WP','WH','SD','SP','SH','has.C1','has.C2','has.C3',
                    'has.C4','has.C5','has.C6','has.C7','has.C8','has.C9','has.C95','has.C96',
                    'has.C97','has.C98','has.C99','SUPD')
   a.df$C1<-as.character(a.df$C1)
   expect_equal(a.df,ObsUnpack(a.string))

})
