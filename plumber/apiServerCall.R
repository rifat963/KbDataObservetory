library(SPARQL)
library(jsonlite)
library(cronR)
library(stringr)
#library(taskscheduleR)


#* @get /getSchedulerResults
getSchedulerResults<-function(schedulerName){
 destfile=paste("/usr/local/lib/R/site-library/cronR/extdata/saveData/",schedulerName,sep 
= "")
  if(file.exists(destfile)){
  df<- read.csv(destfile,header = T)
  df$result="file"
  toJSON(df)
   }else{
    dt= data.frame(result="nofile")
    toJSON(dt)
  }
}

#* @get /addSchedulerIndex
createSchedulerIndex<-function(schedulerName){
  
    st<-read.csv("/root/index/scheduleIndex.csv",header = T)
    df<-data.frame(schedulerName=schedulerName,location="/usr/local/lib/R/site-library/cronR/extdata/",
                   saveData="/usr/local/lib/R/site-library/cronR/extdata/saveData")
    
    #df$schedulerName<-schedulerName
    #df$location<-"/usr/local/lib/R/site-library/cronR/extdata/"
    #df$saveData<-"/usr/local/lib/R/site-library/cronR/extdata/saveData"
    df<-rbind(st,df)
    
    write.csv(df,"/root/index/scheduleIndex.csv",row.names = F)
    rm(df)
   
    list(result="success")
    
}
  
#* @get /readSchedulerIndex
createSchedulerIndex<-function(){
  st<-read.csv("/root/index/scheduleIndex.csv",header = T)
  toJSON(st)    
}

#* @get /updateSchedulerIndex
createSchedulerIndex<-function(schedulerName){
  
  DF<-read.csv("/root/index/scheduleIndex.csv",header = T)
  
  ind <- which(with( DF, schedulerName==schedulerName))
  
  DF <- DF[ -ind, ]
  
  write.csv(data.frame(DF),"/root/index/scheduleIndex.csv",row.names = F)
  rm(DF)    
}


#* @get /addSchedulerIndex
createSchedulerIndex<-function(schedulerName){
  
  st<-read.csv("/srv/shiny-server/KBDataObservetory/schedulerIndex/scheduleIndex.csv",header = T)
  df<-data.frame(schedulerName<-schedulerName,location<-"/usr/local/lib/R/site-library/cronR/extdata/",
                 saveData<-"/usr/local/lib/R/site-library/cronR/extdata/saveData")
  df<-rbind(st,df)
  
  write.csv(df,"/srv/shiny-server/KBDataObservetory/schedulerIndex/scheduleIndex.csv",row.names = F)
  rm(df)    
}

#* @get /readSchedulerIndex
createSchedulerIndex<-function(){
  st<-read.csv("/srv/shiny-server/KBDataObservetory/schedulerIndex/scheduleIndex.csv",header = T)
  toJSON(st)    
}

#* @get /updateSchedulerIndex
createSchedulerIndex<-function(schedulerName){
  
  DF<-read.csv("/srv/shiny-server/KBDataObservetory/schedulerIndex/schedulerList.csv",header = T)
  
  ind <- which(with( DF, schedulerName==schedulerName))
  
  DF <- DF[ -ind, ]
  
  write.csv(data.frame(DF),"/srv/shiny-server/KBDataObservetory/schedulerIndex/schedulerList.csv",row.names = F)
  rm(DF)    
}


#* @get /readCSV
readCSVfiles<-function(schedulerName){
  st<-read.csv(paste("/usr/local/lib/R/site-library/cronR/extdata/saveData/",schedulerName,sep=""),header = T)
  toJSON(st)

}


#* @get /createCornJob
createCornJob<-function(schedulerName,freq,time){
  
  name<-paste(schedulerName,".R",sep = "")
  f <- system.file(package = "cronR", "extdata", name)
  cmd <- cron_rscript(f)
  
  if(freq=="minutely")
    cron_add(cmd, frequency = 'minutely', id = schedulerName)
  if(freq=="daily")
    cron_add(cmd, frequency = 'daily', id = schedulerName , at = time)
  if(freq=="hourly")
    cron_add(cmd, frequency = 'hourly', id = schedulerName)
  
  list(result="success")
}

#* @get /getAllCornList
getAllCornList<-function(){
  cron_ls()
}


#* @get /deleteAllCorn
deleteAllCorn<-function(){
  cron_clear(ask=FALSE)
}



#* @get /createRfile
createRfile<-function(schedulerName,className,endpoint,graph){
  
  # schedulerName="/Api/yy.R"
  # endpoint<-"http://kb.3cixty.com/sparql"
  # cln<-"dul:Place"
  # graph<-"<http://3cixty.com/nice/places>"
  
  className<-gsub("#", "%23", className)
  graph<-gsub("#", "%23", graph)
  
  file<-paste("schedulerName=","\"",schedulerName,".csv\"",sep="")
  end<-paste("endpoint=","\"",endpoint,"\"",sep="")
  class<-paste("className=","\"",className,"\"",sep="")
  grp<-paste("graph=","\"",graph,"\"",sep="")
  
  
  sink(paste("/usr/local/lib/R/site-library/cronR/extdata","/",schedulerName,".R",sep=""))
  cat("library(SPARQL)")
  cat("\n")
  cat("library(jsonlite)")
  cat("\n")
  cat("library(httr)")
  cat("\n")
  cat("library(RCurl)")
  cat("\n")
  cat(file)
  cat("\n")
  cat(end)
  cat("\n")
  cat(class)
  cat("\n")
  cat(grp)
  cat("\n")
  # 3cixty Sparql endpoint
  cat("parm<-paste(\"http://178.62.126.59:9500/\",\"runQuery?schedulerName=\",schedulerName,\"&className=\",
      className,\"&endpoint=\",endpoint,\"&graph=\",graph,sep = \"\")")  
  cat("\n")
  cat("r<-GET(parm)")   
  cat("\n")
  cat("rd<-content(r)")
  cat("\n")
  cat("df <- fromJSON(rd[[1]])") 
  cat("\n")
  cat("destfile=paste(\"/usr/local/lib/R/site-library/cronR/extdata/saveData/\",schedulerName,sep = \"\")")
  cat("\n")
  cat("if(file.exists(destfile)){")
  cat("\n")
  cat("ddf<- read.csv(destfile,header = T)")
  cat("\n")
  cat("ddf<- rbind(ddf,df)}else{ddf<-df}")
  cat("\n")
  cat("write.csv(ddf , destfile,row.names = FALSE)")
  cat("\n")
  cat("rm(ddf)")
  cat("\n")
  cat("list(result=\"success\")")
  cat("\n")
  sink()
  
  list(result="success")
}


sparlQuery_snapsots_summary_properties<-function(endpoint,className,graph){
  
  tryCatch(
    ## This is what I want to do:
    if(graph=="NoGraph"){
      
      query<-"SELECT ?p (COUNT(?p) as ?freq) WHERE { ?s ?p ?o. ?s a"
      query<-paste(query,className,sep = " ")
      query<-paste(query,".}",sep = " ")
      # print(query)
      query_data <- SPARQL(endpoint,query)
      # query results for all the class in a given version
      query_result <- query_data$results
      
      query_result$Release<-Sys.Date()
      query_result$className<-className
      
      query_count<-"SELECT count(*) where { ?s a"
      query_count<-paste(query_count,className,sep = " ")
      query_count<-paste(query_count,".}",sep=" ")
      
      
      query_data_count <- SPARQL(endpoint,query_count)
      # query results for all the class in a given version
      query_result_count <- query_data_count$results
      
      query_result$Count<-query_result_count$callret.0
      
      # print(query_result)
      
      return(query_result)
      
    }else{
      
      query<-"SELECT ?p (COUNT(?p) as ?freq) where { graph"
      query<-paste(query,graph,sep = " ")
      query<-paste(query,"{?s a",sep = " ")
      query<-paste(query,className,sep = " ")
      query<-paste(query,"} ?s ?p ?o . }")
      
      query_data <- SPARQL(endpoint,query)
      # query results for all the class in a given version
      query_result <- query_data$results
      
      query_result$Release<- Sys.Date()
      query_result$className<-className
      query_result$Graph<-graph
      
      query_count<-"SELECT count(*)  where{ graph "
      query_count<-paste(query_count,graph,sep = " ")
      query_count<-paste(query_count,"{ ?s a",sep = " ")
      query_count<-paste(query_count,className,sep = " ")
      query_count<-paste(query_count,".}}",sep = " ")
      
      query_data_count <- SPARQL(endpoint,query_count)
      # query results for all the class in a given version
      query_result_count <- query_data_count$results
      
      query_result$Count<-query_result_count$callret.0
      # query_result$Count<-239892
      # print(query_result)
      
      return(query_result)
    }
    
    ,
    ## But if an error occurs, do the following: 
    error=function(error_message) {
      message("Connection Error.")
      # message("Here is the actual R error message:")
      message(error_message)
      return(NA)
    }
  )
}

# Api function for run sparql query
#* @get /runQuery
runQuery <- function(schedulerName,className,endpoint,graph){
  
  df<-sparlQuery_snapsots_summary_properties(endpoint,className,graph)
  
  toJSON(df)
  
}
