

Sub updateViewNums(logID, vNums)
    If blog_postFile<1 Then Exit Sub
    Dim LoadArticle, splitStr, getA, i, tempStr
    splitStr = "<"&"%ST(A)%"&">"
    tempStr = ""
    LoadArticle = LoadFromFile("cache/"&LogID&".asp")
    If LoadArticle(0) = 0 Then
        getA = Split(LoadArticle(1), splitStr)
        getA(2) = vNums
        For i = 1 To UBound(getA)
            tempStr = tempStr&splitStr&getA(i)
        Next
        Call SaveToFile (tempStr, "cache/" & LogID & ".asp")
	    if memoryCache = true then
			Application.Lock
			Application(CookieName&"_introCache_"&LogID) = tempStr
			Application.UnLock
		end if
    End If
End Sub


Sub ShowArticle(LogID)
    If (log_ViewArr(5, 0) = memName And log_ViewArr(3, 0) = False) Or stat_Admin Or log_ViewArr(3, 0) = True or Trim(log_ViewArr(20, 0)) <> "" Then
    Else
        showmsg "message error", "this article is private，no access to view ！<br/><a href=""default.asp"">click to back</a>", "ErrorIcon", ""
    End If
    If (Not getCate.cate_Secret) Or (log_ViewArr(5, 0) = memName And getCate.cate_Secret) Or stat_Admin Or (getCate.cate_Secret And stat_ShowHiddenCate) Then
    Else
        showmsg "message error", "this article is private，no access to view ！<br/><a href=""default.asp"">click to back</a>", "ErrorIcon", ""
    End If

    If log_ViewArr(6, 0) Then comDesc = "Desc" Else comDesc = "Asc" End If

    'do you have access to view this blog ?

    Dim CanRead,CheckReadPW
    CanRead = False
    CheckReadPW = md5(Trim(Request.form("PW")))
    
    If CheckReadPW = "D41D8CD98F00B204E9800998ECF8427E" Then 'empty md5
    	CheckReadPW = Session("ReadPassWord_"&LogID)
    Else
    	Session("ReadPassWord_"&LogID) = CheckReadPW
    End If

    If IsNull(Session("CheckOutErr_"&LogID)) Or IsEmpty(Session("CheckOutErr_"&LogID)) Then Session("CheckOutErr_"&LogID) = 0
    If stat_Admin = True Then CanRead = True
    If log_ViewArr(3, 0) Then CanRead = True
    If log_ViewArr(3, 0) = False And log_ViewArr(5, 0) = memName Then CanRead = True
    If Trim(log_ViewArr(20,0)) = CheckReadPW Then CanRead = True

    'load blog from files

    If Trim(log_ViewArr(20, 0)) = "" and blog_postFile>0 Then
        Dim LoadArticle, TempStr, TempArticle
        LoadArticle = LoadFromFile("post/"&LogID&".asp")

        If LoadArticle(0) = 0 Then
            TempArticle = LoadArticle(1)
            TempStr = ""
            If stat_EditAll Or (stat_Edit And memName = log_ViewArr(5, 0)) Then
                TempStr = TempStr&"<a href=""blogedit.asp?id="&LogID&""" title=""edit this blog"" accesskey=""E""><img src=""images/icon_edit.gif"" alt="""" border=""0"" style=""margin-bottom:-2px""/></a> "
            End If

            If stat_DelAll Or (stat_Del And memName = log_ViewArr(5, 0)) Then
                TempStr = TempStr&"<a href=""blogedit.asp?action=del&amp;id="&LogID&""" onclick=""if (!window.confirm('remove this blog ?')) return false"" title=""remove this blog"" accesskey=""K""><img src=""images/icon_del.gif"" alt="""" border=""0"" style=""margin-bottom:-2px""/></a>"
            End If

            TempArticle = Replace(TempArticle, "<"&"%ST(A)%"&">", "")
            TempArticle = Replace(TempArticle, "<$EditAndDel$>", TempStr)
            TempArticle = Replace(TempArticle, "<$log_ViewNums$>", log_ViewArr(4, 0))

            response.Write TempArticle
            ShowComm LogID, comDesc, log_ViewArr(7, 0), False, log_ViewArr(3, 0), log_ViewArr(23,0), CanRead 
            Call updateViewNums(id, log_ViewArr(4, 0))
        Else
            response.Write "loading error.<br/>" & LoadArticle(0) & " : " & LoadArticle(1)
        End If
        Exit Sub
    End If

    'load blog from database
    'on error resume Next
    Set preLog = Conn.Execute("SELECT TOP 1 T.log_Title,T.log_ID FROM blog_Content As T,blog_Category As C WHERE T.log_PostTime<#"&DateToStr(log_ViewArr(9, 0), "Y-m-d H:I:S")&"# and T.log_CateID=C.cate_ID and (T.log_IsShow=true or T.log_Readpw<>'') and C.cate_Secret=False and T.log_IsDraft=false ORDER BY T.log_PostTime DESC")
    Set nextLog = Conn.Execute("SELECT TOP 1 T.log_Title,T.log_ID FROM blog_Content As T,blog_Category As C WHERE T.log_PostTime>#"&DateToStr(log_ViewArr(9, 0), "Y-m-d H:I:S")&"# and T.log_CateID=C.cate_ID and (T.log_IsShow=true or T.log_Readpw<>'') and C.cate_Secret=False and T.log_IsDraft=false ORDER BY T.log_PostTime ASC")
    SQLQueryNums = SQLQueryNums + 2

%>
					   <div id="Content_ContentList" class="content-width"><a name="body" accesskey="B" href="#body"></a>
					   <div class="pageContent">
						   <div style="float:right;width:auto">
						   <%
If Not preLog.EOF Then
    	if blog_postFile = 2 then
    		urlLink = caload(preLog("log_ID"))
    	else 
    		urlLink = "?id="&preLog("log_ID")
    	end if
    response.Write ("<a href="""&urlLink&""" title=""last blog: "&preLog("log_Title")&""" accesskey="",""><img border=""0"" src=""images/Cprevious.gif"" alt=""""/>last</a>")
Else
    response.Write ("<img border=""0"" src=""images/Cprevious1.gif"" alt=""this is latest blog""/>last")
End If
If Not nextLog.EOF Then
    	if blog_postFile = 2 then
    		urlLink = caload(nextLog("log_ID"))
    	else 
    		urlLink = "?id="&nextLog("log_ID")
    	end if
    response.Write (" | <a href="""&urlLink&""" title=""next blog: "&nextLog("log_Title")&""" accesskey="".""><img border=""0"" src=""images/Cnext.gif"" alt=""""/>next</a>")
Else
    response.Write (" | <img border=""0"" src=""images/Cnext1.gif"" alt=""this is rnd""/>next")
End If
preLog.Close
nextLog.Close
Set preLog = Nothing
Set nextLog = Nothing

%>
						   </div>
 						   <img src="<%=getCate.cate_icon%>" style="margin:0px 2px -4px 0px" alt=""/> <strong><a href="default.asp?cateID=<%=log_ViewArr(1,0)%>" title="view allof【<%=getCate.cate_Name%>】's blog'"><%=getCate.cate_Name%></a></strong> <a href="feed.asp?cateID=<%=log_ViewArr(1,0)%>" target="_blank" title="subscribe【<%=getCate.cate_Name%>】" accesskey="O"><img border="0" src="images/rss.png" alt="subscribe【<%=getCate.cate_Name%>】" style="margin-bottom:-1px"/></a>
					   </div>
					   <div class="Content">
					   <div class="Content-top"><div class="ContentLeft"></div><div class="ContentRight"></div>
					     <h1 class="ContentTitle"><strong>
							 <%If CanRead Then%>
							 <%=HtmlEncode(log_ViewArr(2, 0))%>
							 <% Else %>
							 <%If log_ViewArr(22, 0) = False then%><%=HtmlEncode(log_ViewArr(2, 0))%><%ElseIf Trim(log_ViewArr(20, 0)) <> "" Then%>[security blog]<%Else%>[private blog]<%End If%>
							 <% End If %>
							 </strong> 
							 <%if log_ViewArr(3, 0)=False or getCate.cate_Secret then%>
							 <%If Trim(log_ViewArr(20, 0)) <> "" Then%><img src="images/icon_lock2.gif" style="margin:0px 0px -3px 2px;" alt="security blog" /><%Else%><img src="images/icon_lock1.gif" style="margin:0px 0px -3px 2px;" alt="private blog" /><%End If%>
							 <%end if%>
							 </h1>
					     <h2 class="ContentAuthor">author:<%=log_ViewArr(5,0)%> date:<%=DateToStr(log_ViewArr(9,0),"Y-m-d")%></h2>
					   </div>
					    <div class="Content-Info">
						  <div class="InfoOther">font size: <a href="javascript:SetFont('12px')" accesskey="1">small</a> <a href="javascript:SetFont('14px')" accesskey="2">medium</a> <a href="javascript:SetFont('16px')" accesskey="3">big</a></div>
						  <div class="InfoAuthor"><img src="images/weather/hn2_<%=log_ViewArr(14,0)%>.gif" style="margin:0px 2px -6px 0px" alt=""/><img src="images/weather/hn2_t_<%=log_ViewArr(14,0)%>.gif" alt=""/> <img src="images/<%=log_ViewArr(15,0)%>.gif" style="margin:0px 2px -1px 0px" alt=""/>
						    <%if stat_EditAll or (stat_Edit and log_ViewArr(5,0)=memName) then %>　<a href="blogedit.asp?id=<%=log_ViewArr(0,0)%>" title="edit this blog" accesskey="E"><img src="images/icon_edit.gif" alt="" border="0" style="margin-bottom:-2px"/></a><%end if%>
					        <%if stat_DelAll or (stat_Del and log_ViewArr(5,0)=memName)  then %>　<a href="blogedit.asp?action=del&amp;id=<%=log_ViewArr(0,0)%>" onclick="if (!window.confirm('delete this blog ？')) return false" accesskey="K"><img src="images/icon_del.gif" alt="" border="0" style="margin-bottom:-2px"/></a><%end if%>
						  </div>
						</div>
					  <div id="logPanel" class="Content-body">
						<%If CanRead Then 'access by password

							keyword = CheckStr(Request.QueryString("keyword"))
							If log_ViewArr(10, 0) = 1 Then
							    response.Write (highlight(UnCheckStr(UBBCode(HtmlEncode(log_ViewArr(8, 0)), Mid(log_ViewArr(11, 0), 1, 1), Mid(log_ViewArr(11, 0), 2, 1), Mid(log_ViewArr(11, 0), 3, 1), Mid(log_ViewArr(11, 0), 4, 1), Mid(log_ViewArr(11, 0), 5, 1))), keyword))
							Else
							    response.Write (highlight(UnCheckStr(log_ViewArr(8, 0)), keyword))
							End If
						Else
						%>
						<div>
							<h5 class="tips"><img alt="security blog" style="margin: 0px 0px -3px 2px;" src="images/icon_lock2.gif"/> need correct password to view ！</h5>
							<div class="tips_body">
								<%if Session("CheckOutErr_"&LogID) >=2 Then 'out of range%>
									<div class="error">inputed verify times over regular times，blog blocked！</div>
								<%
								Else
									dim pwTips
									pwTips = Trim(log_ViewArr(21,0))
								%>
									<form id="CheckRead" name="CheckRead" method="post" action="">
										<%If Trim(Request.Form("do")) = "CheckOut" Then
											Session("CheckOutErr_"&LogID) = Session("CheckOutErr_"&LogID) + 1
											response.write "<div class=""error"">password error , you have " & 3 - Session("CheckOutErr_"&LogID) & " times to vierify</div>"
										 End If%>
										<input name="do" type="hidden" value="CheckOut" />
										<label for="pw"><input name="pw" type="password" id="pw" size="15" class="input"/></label>
										<input type="image" name="Submit" value="confirm" src="images/unlock.gif" style="margin-bottom:-8px;*margin-bottom:-6px"/> <%if pwTips="" then%>『no notice now』<%else%><a href="javascript:;" onclick="$('hints').style.display=$('hints').style.display=='none'?'':'none';" title="display/hide password notice">password notice</a><%end if%>
										<div id="hints" class="hints" style="display:none">
											<%=pwTips%>
										</div>
									</form>
								<%end if%>
							</div>
						</div>
					<%
					End If	
					%>
					   <br/><br/>
					   </div>
					   <div class="Content-bottom"><div class="ContentBLeft"></div>
					    <p><%if len(log_ViewArr(16,0))>0 then response.write ("<div class=""Modify"">"&log_ViewArr(16,0)&"</div>")%>
						<img src="images/From.gif" style="margin:4px 2px -4px 0px" alt=""/><strong>blog from:</strong> <a href="<%=log_ViewArr(17,0)%>" target="_blank"><%=log_ViewArr(18,0)%></a></p>
						<p><img src="images/icon_trackback.gif" style="margin:4px 2px -4px 0px" alt=""/><strong>use notice:</strong> <a href="<%="trackback.asp?tbID="&id&"&amp;action=view"%>" target="_blank">view all index</a> | <a href="javascript:;" title="get link of this blog" onclick="getTrackbackURL(<%=id%>)">i will use this blog</a></p>
					   	<p><%Dim getTag
					   	Set getTag = New tag
					   	%>
						 <img src="images/tag.gif" style="margin:4px 2px -4px 0px" alt=""/><strong>Tags:</strong> <%=getTag.filterHTML(log_ViewArr(19,0))%></p>
						 <p><img src="images/notify.gif" style="margin:4px 2px -4px 0px" alt=""/><strong>other blogs:</strong>
						 <div class="Content-body" id="related_tag" style="margin-left:25px"></div>
						 <script language="javascript" type="text/javascript">check('Getarticle.asp?id=<%=LogID%>&blog_postFile=1','related_tag','related_tag')</script></p>
<p>comments: <%=log_ViewArr(12,0)%> | index: <%=log_ViewArr(13,0)%> | view times: <%=log_ViewArr(4,0)%></p><div class="ContentBRight"></div>
					   </div></div>
					   <br/><br/>
					   </div>
<%Set getTag = Nothing
ShowComm LogID, comDesc, log_ViewArr(7, 0), False, log_ViewArr(3, 0), log_ViewArr(23,0), CanRead  '显示评论内容
End Sub


'*******************************************
'  display comments to blog
'*******************************************

Function ShowComm(ByVal LogID,ByVal comDesc, ByVal DisComment, ByVal forStatic, ByVal logShow, ByVal logPwcomm, ByVal CanRead)
	ShowComm = ""
    ShowComm = ShowComm&"<a name=""comm_top"" href=""#comm_top"" accesskey=""C""></a>"
    
    Dim blog_Comment, Pcount, comm_Num, blog_CommID, blog_CommAuthor, blog_CommContent, Url_Add, commArr, commArrLen,BaseUrl,aName,aEvent
    Set blog_Comment = Server.CreateObject("Adodb.RecordSet")
    
    Pcount = 0
    BaseUrl = ""
    aEvent = ""
    
   ' query with trackback
   ' SQL = "SELECT comm_ID,comm_Content,comm_Author,comm_PostTime,comm_DisSM,comm_DisUBB,comm_DisIMG,comm_AutoURL,comm_PostIP,comm_AutoKEY FROM blog_Comment WHERE blog_ID="&LogID&" UNION ALL SELECT 0,tb_Intro,tb_Title,tb_PostTime,tb_URL,tb_Site,tb_ID,0,'127.0.0.1',0 FROM blog_Trackback WHERE blog_ID="&LogID&" ORDER BY comm_PostTime "&comDesc
  
   ' query without trackback ，high speed
   SQL = "SELECT comm_ID,comm_Content,comm_Author,comm_PostTime,comm_DisSM,comm_DisUBB,comm_DisIMG,comm_AutoURL,comm_PostIP,comm_AutoKEY FROM blog_Comment WHERE blog_ID="&LogID&" ORDER BY comm_PostTime "&comDesc

    blog_Comment.Open SQL, Conn, 1, 1
    SQLQueryNums = SQLQueryNums + 1
    If (blog_Comment.EOF And blog_Comment.BOF) or (logPwcomm = True and CanRead = False) Then
    
    Else
        blog_Comment.PageSize = blogcommpage
        blog_Comment.AbsolutePage = CurPage
        comm_Num = blog_Comment.RecordCount

        commArr = blog_Comment.GetRows(comm_Num)
        blog_Comment.Close
        Set blog_Comment = Nothing
        commArrLen = UBound(commArr, 2)

        Url_Add = "?id="&LogID&"&"
        aName = "#comm_top"
        
        If blog_postFile = 2 and logShow then 'static pages use # to change
        	BaseUrl = caload(LogID)
        	Url_Add="#"
        	aName = ""
        	aEvent = "onclick=""openCommentPage(this)"""
        End If 
        
		'change pages at top
  	   ShowComm = ShowComm&"<div class=""pageContent"">"&MultiPage(comm_Num,blogcommpage,CurPage,Url_Add,aName,"float:right", BaseUrl,aEvent)&"</div>"

	   'display comments
		Do Until Pcount = commArrLen + 1 Or Pcount = blogcommpage
		    blog_CommID = commArr(0, Pcount)
		    blog_CommAuthor = commArr(2, Pcount)
		    blog_CommContent = commArr(1, Pcount)
     		ShowComm = ShowComm&"<div class=""comment""><div class=""commenttop""><span class=""ownerClassComment"" style=""float:right;cursor:pointer"" onclick=""replyMsg("&LogID&","&blog_CommID&","&commArr(4,Pcount)&","&commArr(7,Pcount)&","&commArr(9,Pcount)&")""><img src=""images/reply.gif"" alt=""reply"" style=""margin-bottom:-2px;""/>reply</span>"
     		ShowComm = ShowComm&"<a name=""comm_"&blog_CommID&""" href=""javascript:addQuote('"&blog_CommAuthor&"','commcontent_"&blog_CommID&"')""><img border=""0"" src=""images/icon_quote.gif"" alt="""" style=""margin:0px 4px -3px 0px""/></a>"
     		ShowComm = ShowComm&"<a href=""member.asp?action=view&memName="&Server.URLEncode(blog_CommAuthor)&"""><strong>"&blog_CommAuthor&"</strong></a>"
     		ShowComm = ShowComm&"<span class=""commentinfo"">["&DateToStr(commArr(3,Pcount),"Y-m-d H:I A")&"<span class=""ownerClassComment""> | <a href=""blogcomm.asp?action=del&amp;commID="&blog_CommID&""" onclick=""return delCommentConfirm()""><img src=""images/del1.gif"" alt=""del"" border=""0""/></a></span>]</span>"
		
			'button of delete
		'	if stat_Admin=true or (stat_CommentDel=true and memName=blog_CommAuthor) then 
		'		response.write (" | <a href=""blogcomm.asp?action=del&amp;commID="&blog_CommID&""" onclick=""if (!window.confirm('delete this comment?')) {return false}""><img src=""images/del1.gif"" alt=""delete this comment"" border=""0""/></a>") 
		'	end if
			
     		'ShowComm = ShowComm&"<div class=""comment""><div class=""commenttop"">"
			'comments
			ShowComm = ShowComm&"</div><div class=""commentcontent"" id=""commcontent_"&blog_CommID&""">"&UBBCode(HtmlEncode(blog_CommContent),commArr(4,Pcount),blog_commUBB,blog_commIMG,commArr(7,Pcount),commArr(9,Pcount))&"</div></div>"
			Pcount = Pcount + 1
		Loop
		
		'change pages at bottom
       ShowComm = ShowComm&"<div class=""pageContent"">"&MultiPage(comm_Num,blogcommpage,CurPage,Url_Add,aName,"float:right" ,BaseUrl,aEvent)&"</div>"
	End If
	
	If not forStatic Then
		Response.write ShowComm
		'output comments
		Call showCommentPost(logID,DisComment,logPwcomm,CanRead)
	End IF
End Function

'===============
' output comments
'===============
Sub ShowCommentPost(ByVal logID, ByVal DisComment, ByVal logPwcomm, ByVal CanRead)
	If DisComment Then 
		Exit Sub
	End IF
	
%>
<div id="MsgContent" style="width:94%;"><div id="MsgHead">output comments</div><div id="MsgBody">
<%
		If Not stat_CommentAdd Then
		    response.Write ("you have no access to output comments ！")
		    response.Write ("</div></div>")
		    Exit Sub
		End If
		If logPwcomm = True and CanRead = False Then
		    response.Write ("need correct password to output and view comments ！")
		    response.Write ("</div></div>")
		    Exit Sub
		End If
		
		%>
		      <script type="text/javascript">
		      		function checkCommentPost(){
		      			if (!CheckPost) return false
						// second method
		      			return true
		      		}
		      </script>
              <%
			  Dim Ts, Ts_UserName, Ts_Content, Ts_True
			  Ts = Request.Cookies(CookieName)("Guest")
			  If len(Ts) > 0 or Ts <> "" Then
			  	If Instr(Ts, "|-|") > 0 Then
					Ts_True = Split(Ts, "|-|")(0)
			  		Ts_UserName = Split(Split(Ts, "|-|")(1), "|$|")(0)
					Ts_Content = Split(Split(Split(Ts, "|-|")(1), "|$|")(1), "|+|")(0)
				End If
			  End If
			  %>
		      <form name="frm" action="blogcomm.asp" method="post" onsubmit="return checkCommentPost()" style="margin:0px;">	  
			  <table width="100%" cellpadding="0" cellspacing="0">	  
			  <tr><td align="right" width="70"><strong>nickname:</strong></td><td align="left" style="padding:3px;"><input name="username" type="text" size="18" class="userpass" maxlength="24" <%
			  if not memName=empty then
			  	response.write ("value="""&memName&""" readonly=""readonly""")
			  else
			  	if Ts_True = "true" then
					response.write ("value="""&Ts_UserName&"""")
				end if
			  end if
			  %>/></td></tr>password:</strong></td><td align="left" style="padding:3px;"><input name="password" type="password" size="18" class="userpass" maxlength="24"/> travelers doesn't need passwords.</td></tr><%end if%>
			  <tr><td align="right" width="70" valign="top"><strong>contens:</strong><br/>
			  </td><td style="padding:2px;">
			   <%
				UBB_TextArea_Height = "150px;"
				UBB_Tools_Items = "bold,italic,underline,deleteline"
				UBB_Tools_Items = UBB_Tools_Items&"||image,link,mail,quote,smiley"
				Response.write (UBBeditorCore("Message"))
				if memName = empty then
			  		if Ts_True = "true" then
						response.write ("<script>$('editMask').value = """&Ts_Content&""";document.forms[0].Message.value="""&Ts_Content&"""</script>")
					end if
			  	end if 
				%>
			  </td></tr>
			  <%if (memName=empty or blog_validate=true) and stat_Admin=false then%><tr><td align="right" width="70"><strong>verify code:</strong></td><td align="left" style="padding:3px;"><input name="validate" type="text" size="4" class="userpass" maxlength="4" onfocus="this.select()"/> <%=getcode()%></td></tr><%end if%>
			  <tr><td align="right" width="70" valign="top"><strong>select:</strong></td><td align="left" style="padding:3px;">
		             <label for="label5"><input name="log_DisSM" type="checkbox" id="label5" value="1" />emoticons' change is banned</label>
		             <label for="label6"><input name="log_DisURL" type="checkbox" id="label6" value="1" />links' change is banned</label>
		             <label for="label7"><input name="log_DisKey" type="checkbox" id="label7" value="1" />keywords's change is banned</label>
                     <%if not len(memName) > 0 then%>
                     <span id="GuestCanRemeberComment"><br />
                    <label for="label8"><input name="log_GuestCanRemeberComment" type="checkbox" id="label8" value="1" id="e_GuestCanRemeberComment" checked="checked"/>remember my informations, so that when i don't need to input username to make comments next time.</label></span>
                    <%end if%>
			  </td></tr>
		          <tr>
		            <td colspan="2" align="center" style="padding:3px;">
					  <input name="logID" type="hidden" value="<%=LogID%>"/>
		              <input name="action" type="hidden" value="post"/>
					  <input name="submit2" type="submit" class="userbutton" value="post comments" accesskey="S"/>
		              <input name="button" type="reset" class="userbutton" value="rewrite"/></td>
		          </tr>
		          <tr>
		            <td colspan="2" align="right" >
					 <%if memName=empty then%>
					 	although no need to register to make comments，but still advice you to register for safety of your comments<a href="register.asp">register</a>. <br/>
					 <%end if%>
			  words limit <b><%=blog_commLength%> word</b> |
			  UBB code <b><%if (blog_commUBB=0) then response.write ("on") else response.write ("off") %></b> |
			  [img]label <b><%if (blog_commIMG=0) then response.write ("on") else response.write ("off") %></b>
		
					</td>
		          </tr>		  
			  </table></form>
	<%response.Write ("</div></div>")
end Sub
%>