<!--#include file="BlogCommon.asp" -->
<!--#include file="header.asp" -->
<!--#include file="common/ModSet.asp" -->
<!--#include file="common/UBBconfig.asp" -->
<!--#include file="class/cls_article.asp" -->
<!--#include file="common/sha1.asp" -->
<!--#include file="plugins.asp" -->

<%
'==================================
' display blog
'==================================
'process blog

Dim id, tKey
If CheckStr(Request.QueryString("id"))<>Empty Then
    id = CheckStr(Request.QueryString("id"))
End If
Dim log_View, log_ViewArr, keyword, preLog, nextLog, blog_Cate, blog_CateArray, comDesc, urlLink
Dim getCate,viewCount
Set getCate = New Category
If IsInteger(id) Then
    Set log_View = Server.CreateObject("ADODB.RecordSet")
    'If blog_postFile>1 Then
        'SQL = "SELECT top 1 log_ID,log_CateID,log_title,Log_IsShow,log_ViewNums,log_Author,log_comorder,log_DisComment,log_Readpw,log_Pwtips,log_Pwtitle,log_Pwcomm,log_KeyWords,log_Description FROM blog_Content WHERE log_ID="&id&" and log_IsDraft=false"
    'Else
        SQL = "SELECT top 1 log_ID,log_CateID,log_title,Log_IsShow,log_ViewNums,log_Author,log_comorder,log_DisComment,log_Content,log_PostTime,log_edittype,log_ubbFlags,log_CommNums,log_QuoteNums,log_weather,log_level,log_Modify,log_FromUrl,log_From,log_tag,log_Readpw,log_Pwtips,log_Pwtitle,log_Pwcomm,log_KeyWords,log_Description FROM blog_Content WHERE log_ID="&id&" and log_IsDraft=false"
    'End If

    log_View.Open SQL, Conn, 1, 3
    SQLQueryNums = SQLQueryNums + 1
    If log_View.EOF Or log_View.bof Then
        log_View.Close
        showmsg "error", "this blog is not exist！<br/><a href=""default.asp"">click to back</a>", "ErrorIcon", ""
    End If
    viewCount = log_View("log_ViewNums") + 1
    log_View("log_ViewNums") = viewCount
    log_View.UPDATE
    log_ViewArr = log_View.GetRows
    log_View.Close
    Set log_View = Nothing
    getCate.load(Int(log_ViewArr(1, 0))) 'get category
    
    If blog_postFile>1 Then
		Call updateViewNums(id, viewCount)
	end if
	
    If log_ViewArr(3, 0) And Not getCate.cate_Secret Then
        BlogTitle = log_ViewArr(2, 0) & " - " & siteName
    End If
Else
    showmsg "error", "illegal operate", "ErrorIcon", ""
End If
getBlogHead BlogTitle, getCate.cate_Name, getCate.cate_ID, log_ViewArr(24, 0), log_ViewArr(25, 0)
tKey = getTempKey
%>
 <!--内容-->
  <div id="Tbody">
  <div id="mainContent">
   <div id="innermainContent">
       <div id="mainContent-topimg"></div>
	   <%=content_html_Top%>
	   <%
If id<>"" And IsInteger(id) = False Then
    response.Write ("illegal operate！！")
Else
    ShowArticle id 'display blog
End If
Set getCate = Nothing

%>
	   <%=content_html_Bottom%>
       <div id="mainContent-bottomimg"></div>
   </div>
   </div>
   <%Side_Module_Replace 'process sidebar%>
   <div id="sidebar">
	   <div id="innersidebar">
		     <div id="sidebar-topimg"><!--images in top of toolbar--></div>
			  <%=side_html%>
		     <div id="sidebar-bottomimg"></div>
	   </div>
   </div>
   <div style="clear: both;height:1px;overflow:hidden;margin-top:-1px;"></div>
  </div>
  <!--#include file="footer.asp" -->
