<!--#include file="commond.asp" -->
<!--#include file="header.asp" -->
<!--#include file="common/UBBconfig.asp" -->
<!--#include file="FCKeditor/fckeditor.asp" -->
<!--#include file="common/ModSet.asp" -->
<!--#include file="class/cls_logAction.asp" -->
<!--#include file="class/cls_article.asp" -->
<div id="Tbody">
    <div style="text-align:center;"><br/>
<%
'==================================
'  edit and delete
'==================================
Dim logid
Dim preLog, nextLog, getTag
Dim loadTag, loadTags

logid = Trim(CheckStr(Request("id")))
If ChkPost() Then
    If logid = Empty Or IsInteger(logid) = False Then

%>
        <div id="MsgContent" style="width:350px">
         <div id="MsgHead">error</div>
         <div id="MsgBody">
   		 <div class="ErrorIcon"></div>
           <div class="MessageText"><b>illegal operate!</b><br/>
           <a href="javascript:history.go(-1)">click to back to last page</a> 
   		 </div>
   	 </div>
   	</div>
   <%Else
    Dim lArticle, EditLog, DeleteLog
    Set lArticle = New logArticle
    editLog = lArticle.getLog(logid)

    If stat_EditAll Or (stat_Edit And lArticle.logAuthor = memName) Then
%>
    <!--contents-->
   <%If Request.Form("action") = "post" Then
    Dim pws, pwtips, pwtitle, pwcomm, IsShow, keyword, description
		pws = Trim(Request.Form("log_Readpw"))
		pwtips = Trim(Request.Form("log_Pwtips"))
		pwtitle = Request.Form("log_Pwtitle")
		pwcomm = Request.Form("log_Pwcomm")
		keyword = Trim(Request.Form("log_KeyWords"))
		description = Trim(Request.Form("log_Description"))
    If CheckStr(Request.Form("log_IsHidden")) = "1" Then
			IsShow = False
			If CheckStr(Request.Form("c_pws")) = "1" Then' if password changed
				If IsEmpty(pws) or IsNull(pws) or pws = "" Then
				Else
					pws = md5(pws)
				End If
			End If 
			If pws = "" Then pwtips = ""
    Else
			IsShow = True
			pws = ""
			pwtips = ""
			pwtitle = False
			pwcomm = False
    End If
    If Request.Form("log_pws") = "0" Then
			pws = ""
			pwtips = ""
    End If
    If CheckStr(Request.Form("log_Meta")) = "0" Then
			keyword = ""
			description = ""
    End If
    
    lArticle.categoryID = request.Form("log_CateID")
    lArticle.logTitle = request.Form("title")
    lArticle.logAuthor = memName
    lArticle.logEditType = request.Form("log_editType")
    lArticle.logIntroCustom = request.Form("log_IntroC")
    lArticle.logIntro = request.Form("log_Intro")
    lArticle.logWeather = request.Form("log_weather")
    lArticle.logLevel = request.Form("log_Level")
    lArticle.logCommentOrder = request.Form("log_comorder")
    lArticle.logDisableComment = request.Form("log_DisComment")
    lArticle.logIsShow = IsShow
    lArticle.logIsTop = request.Form("log_IsTop")
    lArticle.logIsDraft = request.Form("log_IsDraft")
    lArticle.logFrom = request.Form("log_From")
    lArticle.logFromURL = request.Form("log_FromURL")
    lArticle.logDisableImage = request.Form("log_disImg")
    lArticle.logDisableSmile = request.Form("log_DisSM")
    lArticle.logDisableURL = request.Form("log_DisURL")
    lArticle.logDisableKeyWord = request.Form("log_DisKey")
    lArticle.logMessage = request.Form("Message")
    lArticle.logTrackback = request.Form("log_Quote")
    lArticle.logTags = request.Form("tags")
    lArticle.logPubTime = request.Form("PubTime")
    lArticle.logPublishTimeType = request.Form("PubTimeType")
    If blog_postFile = 2 Then
    lArticle.logCname = request.Form("Cname")
    lArticle.logCtype = request.Form("Ctype")
    End If
    lArticle.logReadpw = pws
    lArticle.logPwtips = pwtips
    lArticle.logPwtitle = pwtitle
    lArticle.logPwcomm = pwcomm
    lArticle.logMeta = request.Form("log_Meta")
    lArticle.logKeyWords = keyword
    lArticle.logDescription = description
    EditLog = lArticle.editLog(request.Form("id"))
    Set lArticle = Nothing

%>
		      <div id="MsgContent" style="width:300px">
		        <div id="MsgHead">feedback</div>
		        <div id="MsgBody">
		  		 <div class="<%if EditLog(0)<0 Then response.write "ErrorIcon" else response.write "MessageIcon"%>"></div>
		          <div class="MessageText"><%=EditLog(1)%><br/><a href="default.asp">back to homepage</a><br/>
		  		 <%if EditLog(0)>=0 Then %>
			      	 <a href="default.asp?id=<%=EditLog(2)%>">back tpp your edit</a><br/>
		  		     <meta http-equiv="refresh" content="3;url=default.asp?logID=<%=EditLog(2)%>"/>
			     <%end if%>
		  	  </div>
		  	</div>
		    </div>
		    <%
ElseIf Request.QueryString("action") = "del" Or Request.Form("action") = "del" Then
    DeleteLog = lArticle.deleteLog(request("id"))
    Set lArticle = Nothing

%>
		      <div id="MsgContent" style="width:300px">
		        <div id="MsgHead">feedback</div>
		        <div id="MsgBody">
		  		 <div class="<%if DeleteLog(0)<0 Then response.write "ErrorIcon" else response.write "MessageIcon"%>"></div>
		          <div class="MessageText"><%=DeleteLog(1)%><br/><a href="default.asp">back to homepage</a><br/>
		  	  </div>
		  	</div>
		    </div>
		    <%
Else

    If editLog(0)<0 Then

%>
        <div id="MsgContent" style="width:350px">
         <div id="MsgHead">error</div>
         <div id="MsgBody">
   		 <div class="ErrorIcon"></div>
           <div class="MessageText"><b><%=editLog(1)%></b><br/>
           <a href="default.asp">back to homepage</a> 
   		 </div>
   	 </div>
   	</div>
   <%
Else
    Dim log_editType, editTs
    log_editType = lArticle.logEditType

%>
   
   <!--second-->
     <form name="frm" action="blogedit.asp" method="post" onSubmit="return CheckPost()" style="margin:0px">
                <input name="id" type="hidden" id="id" value="<%=logid%>"/>
                <input name="log_editType" type="hidden" id="log_editType" value="<%=log_editType%>"/>
   				<input id="action" name="action" type="hidden" value="post"/>
                <input name="FirstPost" type="hidden" value="1"/>   
                <input name="postbackId" type="hidden" value="<%=logid%>"/>
                <input name="log_IsDraft" type="hidden" id="log_IsDraft" value="<%=lArticle.logIsDraft%>"/>
   	<div id="MsgContent" style="width:630px;float:left; margin-left:20px;">
         <div id="MsgHead">edit</div>
         <div id="MsgBody">        
           <table width="100%" border="0" cellpadding="2" cellspacing="0">
             <tr>
               <td width="76" height="24" align="right" valign="top"><span style="font-weight: bold">title:</span></td>
               <td align="left"><input name="title" type="text" class="inputBox" id="title" size="50" maxlength="50" value="<%=lArticle.logTitle%>"/>
          	 &nbsp;&nbsp;<b> category:</b> <select name="log_CateID" id="select2">
           <%
outCate

Sub outCate
    Dim Arr_Category, Category_Len, i
    Arr_Category = Application(CookieName&"_blog_Category")
    If UBound(Arr_Category, 1) = 0 Then Exit Sub
    Category_Len = UBound(Arr_Category, 2)

    For i = 0 To Category_Len
        If Not Arr_Category(4, i) Then
            If CBool(Arr_Category(10, i)) Then
                If stat_ShowHiddenCate And stat_Admin Then
                    Response.Write("<option value='"&Arr_Category(0, i)&"'")
                    If lArticle.categoryID = Int(Arr_Category(0, i)) Then Response.Write (" selected")
                    Response.Write(">"&Arr_Category(1, i)&"</option>")
                End If
            Else
                Response.Write("<option value='"&Arr_Category(0, i)&"'")
                If lArticle.categoryID = Int(Arr_Category(0, i)) Then Response.Write (" selected")
                Response.Write(">"&Arr_Category(1, i)&"</option>")
            End If
        End If
    Next
End Sub

%>
         </select>
   	</td>
             </tr>
             <!--edit by evio-->
			   <%
			   If blog_postFile = 2 Then
			   dim cdb
			   set cdb=conn.execute("select log_cname,log_ctype from blog_Content where log_ID="&logid&"")
			   %>
			<tr>
              <td height="24" align="right" valign="top"><span style="font-weight: bold">nickname:</span></td>
              <td align="left">
			  <input name="cname" type="text" class="inputBox" id="titles" size="30" maxlength="50" value="<%=trim(cdb("log_cname"))%>" onBlur="check('Action.asp?action=checkAlias&cname='+document.forms['frm'].cname.value,'CheckAlias','CheckAlias')" style="ime-mode:disabled"/>
			   <span> . </span>
			  <select name="ctype">
			    <option value="0" <%if cdb("log_ctype")=0 then%>selected="selected" <%end if%>>htm</option> 
				<option value="1" <%if cdb("log_ctype")=1 then%>selected="selected" <%end if%>>html</option>
			  </select> <span id="CheckAlias"></span>
              </td>
            </tr>
			<input name="oldcname" type="hidden" value="<%=cdb("log_cname")%>">
			<input name="oldtype" type="hidden" value="<%=cdb("log_ctype")%>">
			<input name="oldcate" type="hidden" value="<%=lArticle.categoryID%>">
			<%
			set cdb=nothing
			end if
			%>
			<!--edit by evio-->
             
             <tr>
               <td align="right" valign="top"><span style="font-weight: bold">settings:</span></td>
               <td align="left">
                 <div><select name="log_weather" id="logweather">
                   <option value="sunny" <%if lArticle.logWeather="sunny" Then response.write ("selected=""selected""")%>>sunny </option>
                   <option value="cloudy" <%if lArticle.logWeather="cloudy" Then response.write ("selected=""selected""")%>>cloudy </option>
                   <option value="flurries" <%if lArticle.logWeather="flurries" Then response.write ("selected=""selected""")%>>windy </option>
                   <option value="ice" <%if lArticle.logWeather="ice" Then response.write ("selected=""selected""")%>>ice </option>
                   <option value="ptcl" <%if lArticle.logWeather="ptcl" Then response.write ("selected=""selected""")%>>bad </option>
                   <option value="rain" <%if lArticle.logWeather="rain" Then response.write ("selected=""selected""")%>>rainy </option>
                   <option value="showers" <%if lArticle.logWeather="showers" Then response.write ("selected=""selected""")%>>rain more </option>
                   <option value="snow" <%if lArticle.logWeather="snow" Then response.write ("selected=""selected""")%>>snowy </option>
                 </select>
                 <select name="log_Level" id="logLevel">
                   <option value="level1" <%if lArticle.logLevel="level1" Then response.write ("selected=""selected""")%>>★</option>
                   <option value="level2" <%if lArticle.logLevel="level2" Then response.write ("selected=""selected""")%>>★★</option>
                   <option value="level3" <%if lArticle.logLevel="level3" Then response.write ("selected=""selected""")%>>★★★</option>
                   <option value="level4" <%if lArticle.logLevel="level4" Then response.write ("selected=""selected""")%>>★★★★</option>
                   <option value="level5" <%if lArticle.logLevel="level5" Then response.write ("selected=""selected""")%>>★★★★★</option>
                 </select>
                 <label for="label">
                 <input id="label" name="log_comorder" type="checkbox" value="1" <%if lArticle.logCommentOrder Then response.write ("checked=""checked""")%>/>
         </label>
                 <label for="label2">
                 <input name="log_DisComment" type="checkbox" id="label2" value="1" <%if lArticle.logDisableComment Then response.write ("checked=""checked""")%>/>
        no comments</label>
                 <label for="label3">
                 <input name="log_IsTop" type="checkbox" id="label3" value="1" <%if lArticle.logIsTop Then response.write ("checked=""checked""")%>/>
         select to top</label>

   	            </td>
             </tr>
             <tr>
               <td align="right" valign="top"><span style="font-weight: bold">privates and Meta:</span></td>
               <td align="left"><div>
	 				<label for="Secret">
				    <input id="Secret" name="log_IsHidden" type="checkbox" value="1" onClick="document.getElementById('Div_Password').style.display=(this.checked)?'block':'none'" <%if not lArticle.logIsShow Then response.write ("checked=""checked""")%>/>
	        set privates</label>
	 				<label for="Meta">
				    <input id="Meta" name="log_Meta" type="checkbox" value="1" onclick="document.getElementById('Div_Meta').style.display=(this.checked)?'block':'none'"  <%if lArticle.logMeta Then response.write ("checked=""checked""")%>/>
	        set Meta</label></div>
	                  <div id="Div_Password"  class="tips_body" <%if lArticle.logIsShow Then response.write("style=""display:none;""")%>>
                          <label for="bpws1"><input id="bpws1" type="radio" name="log_pws" value="0" checked/><b>private blog</b></label> - only administrators and who posted can view private blog<br/>
                          <label for="bpws2"><input id="bpws2" type="radio" name="log_pws" value="1" <%if lArticle.logReadpw<>"" Then response.write("checked")%>/><b>security blogs</b></label> - need correct password
                          <br/>&nbsp;&nbsp;&nbsp;&nbsp;
                          <span style="font-weight: bold">password:</span>
                          <input onFocus="this.select();$('bpws2').checked='checked'" onKeyPress="$('c_pws').value=1" name="log_Readpw" type="password" id="log_Readpw" size="12" class="inputBox" title="no need to notice" value="<%=lArticle.logReadpw%>" />
                          <span style="font-weight: bold">&nbsp;&nbsp;password notice:</span>
                          <input onFocus="$('bpws2').checked='checked'" name="log_Pwtips" type="text" id="log_Pwtips" size="35" class="inputBox" title="no need to notice" value="<%=lArticle.logPwtips%>" />
                          <input id="c_pws" name="c_pws" type="hidden" value="0">
                          <label for="bpws3"><input id="bpws3" name="log_Pwtitle" type="checkbox" value="1" <%if lArticle.logPwtitle then response.write ("checked=""checked""")%> />secure notice</label>
                          <label for="bpws4"><input id="bpws4" name="log_Pwcomm" type="checkbox" value="1" <%if lArticle.logPwcomm then response.write ("checked=""checked""")%> />secure comments</label>
	                  </div>
	                  <div id="Div_Meta" class="tips_body" <%if not lArticle.logMeta Then response.write("style=""display:none;""")%>>
      	 				  - set Meta，if it is empty , that will be Tag and abstract of blogs<br/>
		                  <span style="font-weight: bold">KeyWords&nbsp;&nbsp;:</span>
						  <input name="log_KeyWords" type="text" id="log_KeyWords" size="80" class="inputBox" title="input keywords，if no need , just keep empty" value="<%=lArticle.logKeyWords%>" />
						  <br />
						  <span style="font-weight: bold">Description:</span>
						  <input name="log_Description" type="text" id="log_Description" size="80" class="inputBox" title="input Description，if no need, just keep empty" value="<%=lArticle.logDescription%>" />
	                  </div>
				  </td>
             </tr>
             <tr>
               <td height="24" align="right" valign="top"><b>source:</b></td>
               <td align="left"><span style="font-weight: bold"></span>
                   <input name="log_From" type="text" id="log_From" size="12" class="inputBox" value="<%=lArticle.logFrom%>" />
                   <span style="font-weight: bold">website:</span>
                   <input name="log_FromURL" type="text" id="log_FromURL" size="38" class="inputBox" value="<%=lArticle.logFromURL%>"/>
                 </td>
             </tr>
            <tr>
              <td height="24" align="right" valign="top"><span style="font-weight: bold">posted time:</span></td>
              <td align="left">
                 <%if lArticle.logIsDraft Then%>
	                  <label for="P1"><input name="PubTimeType" type="radio" id="P1" value="now" size="12" checked/>present time</label> 
	                  <label for="P2"><input name="PubTimeType" type="radio" id="P2" value="com" size="12" />set date:</label>
	                  <input onfocus="this.select();$('P2').checked='checked'" name="PubTime" type="text" value="<%=DateToStr(lArticle.logPubTime,"Y-m-d H:I:S")%>" size="21" class="inputBox" /> (format:yyyy-mm-dd hh:mm:ss)
                 <%else%>
	                  <label for="P2"><input name="PubTimeType" type="radio" id="P2" value="com" size="12" checked/>set date:</label>
	                  <input name="PubTime" type="text" value="<%=DateToStr(lArticle.logPubTime,"Y-m-d H:I:S")%>" size="21" class="inputBox" /> (format:yyyy-mm-dd hh:mm:ss)
                 <%end if%>
                </td>
            </tr>
            <tr>
              <td height="24" align="right" valign="top"><span style="font-weight: bold">Tags:</span></td>
              <td align="left">
                      <input name="tags" type="text" value="<%=lArticle.logTags%>" size="50" class="inputBox" /> <img src="images/insert.gif" alt="insert using Tag" onClick="popnew('getTags.asp','tag','250','324')" style="cursor:pointer"/> 
               </td>
            </tr>
            <tr>
               <td  align="right" valign="top"><span style="font-weight: bold">contents</span></td>
               <td align="center"><%
If log_editType = 0 Then
    Dim sBasePath
    sBasePath = "FCKeditor/"
    Dim oFCKeditor
    Set oFCKeditor = New FCKeditor
    oFCKeditor.BasePath = sBasePath
    oFCKeditor.Config("AutoDetectLanguage") = False
    oFCKeditor.Config("DefaultLanguage") = "zh-cn"
    oFCKeditor.Value = UnCheckStr(lArticle.logMessage)
    oFCKeditor.Height = "350"
    oFCKeditor.Create "Message"
Else
    UBB_TextArea_Height = "200px;"
    UBB_AutoHidden = False
    UBB_Msg_Value = UBBFilter(UnCheckStr(lArticle.logMessage))
    UBBeditor("Message")
End If

%></td>
             </tr>
            <tr>
              <td align="right" valign="top">&nbsp;</td>
               <td align="left">
  <%if log_editType<>0 then %>
               <label for="label4">
               <label for="label4"><input id="label4" name="log_disImg" type="checkbox" value="1" <%if lArticle.logDisableImage=1 Then response.write ("checked")%>/>
   can't display images</label>
                 <label for="label5">
                 <input name="log_DisSM" type="checkbox" id="label5" value="1" <%if lArticle.logDisableSmile=1 Then response.write ("checked")%>/>
   can't change emoticons </label>
                 <label for="label6">
                 <input name="log_DisURL" type="checkbox" id="label6" value="1" <%if lArticle.logDisableURL=0 Then response.write ("checked")%>/>
   can't change link</label>
                 <label for="label7">
                 <input name="log_DisKey" type="checkbox" id="label7" value="1" <%if lArticle.logDisableKeyWord=0 Then response.write ("checked")%>/>
   can't change keywords</label>
  <%else%>
                 <strong>[&nbsp;&nbsp;<a herf="#" onclick="GetLength();" style="cursor:pointer">statistical</a>&nbsp;&nbsp;|&nbsp;&nbsp;<a herf="#" onclick="SetContents();" style="cursor:pointer">clear contents</a>&nbsp;&nbsp;]</strong>
  <%end if%></td></tr>
             <%
Dim UseIntro
UseIntro = False
UseIntro = CBool(lArticle.logIntroCustom)

%>
           <tr>
               <td align="right" valign="top"><span style="font-weight: bold">abstract of contents:</span></td>
               <td align="left"><div><label for="shC"><input id="shC" name="log_IntroC" type="checkbox" value="1" onClick="document.getElementById('Div_Intro').style.display=(this.checked)?'block':'none'" <%if not UseIntro Then response.write("checked=""checked""")%>/>edit abstract</label></div>
               <div id="Div_Intro" <%if UseIntro Then response.write("style=""display:none""")%>>
               <%
If log_editType = 0 Then
    Dim oFCKeditor1
    Set oFCKeditor1 = New FCKeditor
    oFCKeditor1.BasePath = sBasePath
    oFCKeditor1.Height = "150"
    oFCKeditor1.ToolbarSet = "Basic"
    oFCKeditor1.Config("AutoDetectLanguage") = False
    oFCKeditor1.Config("DefaultLanguage") = "zh-cn"
    oFCKeditor1.Value = UnCheckStr(lArticle.logIntro)
    oFCKeditor1.Create "log_Intro"
Else

%>
   	         <textarea name="log_Intro" class="editTextarea" style="width:99%;height:120px;"><%=UBBFilter(HTMLDecode(UnCheckStr(lArticle.logIntro)))%></textarea>
   	         <%
End If

%></div>
               </td>
           </tr>
           <tr>
               <td align="right" valign="top" nowrap><span style="font-weight: bold">files to upward:</span></td>
               <td align="left"><iframe src="attachment.asp" width="100%" height="24" frameborder="0" scrolling="no" border="0" frameborder="0"></iframe></td>
             </tr>
            <tr>
              <td align="right" valign="top"><span style="font-weight: bold">notice:</span></td>
              <td colspan="2" align="left"><input name="log_Quote" type="text" size="80" class="inputBox" id="logQuote"/><br>input URL </td>
            </tr>
            <tr>
               <td colspan="2" align="center">
                 <input name="SaveArticle" type="submit" class="userbutton" value="save blog" accesskey="S"/>
                 <%if lArticle.logIsDraft Then%>
                    <input name="SaveDraft" type="submit" class="userbutton" value="save and cancel draft" accesskey="D" onClick="document.getElementById('log_IsDraft').value='False'"/>
                 <%end if%>
                 <input name="DelArticle" type="button" class="userbutton" value="delete this blog" accesskey="K" onClick="if (window.confirm('delete or not')) {document.getElementById('action').value='del';document.forms['frm'].submit()}"/>
                 <input name="CancelEdit" type="button" class="userbutton" value="cancel edition" accesskey="Q" onClick="location='default.asp'"/>
               </td>
             </tr>
                 <%if lArticle.logIsDraft Then%>
	             <tr>
	                <td colspan="2" align="right">
	                </td>
	             </tr>
                 <%end if%>
           </table>
         </div>
   	</div>
   </form>
   <%
Set lArticle = Nothing
End If
End If
Else
%>
        <div id="MsgContent" style="width:350px">
         <div id="MsgHead">error</div>
         <div id="MsgBody">
   		 <div class="ErrorIcon"></div>
           <div class="MessageText"><b>no access to change blog</b><br/>
           <a href="default.asp">back to homepage</a> 
   		 </div>
   	 </div>
   	</div>
   <%End If
End If
Else
%>
   <div style="text-align:center;">
    <div id="MsgContent" style="width:300px">
      <div id="MsgHead">post error</div>
      <div id="MsgBody">
		 <div class="ErrorIcon"></div>
        <div class="MessageText">transfer data by other link is not allowed<br/><a href="default.asp">back to homepag</a>
		 <meta http-equiv="refresh" content="3;url=default.asp"/></div>
	  </div>
	</div>
  </div> 
  <%end if%>
  <br/></div> 
 </div>
<!--#include file="plugins.asp" -->
<!--#include file="footer.asp" -->
