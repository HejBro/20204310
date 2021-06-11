<!--#include file="commond.asp" -->
<!--#include file="header.asp" -->
<!--#include file="common/UBBconfig.asp" -->
<!--#include file="FCKeditor/fckeditor.asp" -->
<!--#include file="common/ModSet.asp" -->
<!--#include file="class/cls_logAction.asp" -->
<!--#include file="class/cls_article.asp" -->

<div id="Tbody">
  <div style="text-align:center;">
  <br/>
  <%
'==================================
'  post blog pages
'==================================
Dim preLog, nextLog
If ChkPost() Then
    If stat_AddAll<>True And stat_Add<>True Then
%>
      <div id="MsgContent" style="width:350px">
        <div id="MsgHead">error</div>
        <div id="MsgBody">
  		 <div class="ErrorIcon"></div>
          <div class="MessageText"><b>no access to post!</b><br/>
          <a href="default.asp">back to homepage</a><%if memName=Empty Then %> | <a href="login.asp">login</a><%end if%>
  		 </div>
  	 </div>
  	</div>
  <%else%>
   <!--contents-->
   <%If Request.Form("action") = "post" Then
		Dim lArticle, postLog, pws, pwtips, pwtitle, pwcomm, IsShow, keyword, description
		pws = Trim(Request.Form("log_Readpw"))
		pwtips = Trim(Request.Form("log_Pwtips"))
		pwtitle = Request.Form("log_Pwtitle")
		pwcomm = Request.Form("log_Pwcomm")
		keyword = Trim(Request.Form("log_KeyWords"))
		description = Trim(Request.Form("log_Description"))
    If CheckStr(Request.Form("log_IsHidden")) = "1" Then
			IsShow = False
			If IsEmpty(pws) or IsNull(pws) or pws = "" Then
			Else
				pws = md5(pws)
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
   
	Set lArticle = New logArticle
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
    lArticle.logCname = request.Form("cname")
    lArticle.logCtype = request.Form("ctype")
    End If
    lArticle.logReadpw = pws
    lArticle.logPwtips = pwtips
    lArticle.logPwtitle = pwtitle
    lArticle.logPwcomm = pwcomm
    lArticle.logMeta = request.Form("log_Meta")
    lArticle.logKeyWords = keyword
    lArticle.logDescription = description
    if request.form("FirstPost") = 1 then
		lArticle.isajax = false
		lArticle.logIsDraft = false
		postLog = lArticle.editLog(request.Form("postbackId"))
	else
    	postLog = lArticle.postLog
	end if
    Set lArticle = Nothing


%>
		      <div id="MsgContent" style="width:300px">
		        <div id="MsgHead">feedback</div>
		        <div id="MsgBody">
		  		 <div class="<%if postLog(0)<0 Then response.write "ErrorIcon" else response.write "MessageIcon"%>"></div>
		          <div class="MessageText"><%=postLog(1)%><br/><a href="default.asp">back to homepage</a><br/>
		  		 <%if postLog(0)>=0 Then %>
			  		 <a href="default.asp?id=<%=postLog(2)%>">back to blog which you edited</a><br/>
			  		 <meta http-equiv="refresh" content="3;url=default.asp?logID=<%=postLog(2)%>"/>
			     <%end if%>
		  	  </div>
		  	</div>
		    </div>
		    <%
Else
    If Request.Form("log_CateID") = Empty Then
%>
   <!--first-->
   <script language="javascript">
    function chkFrm(){
     if (document.forms["frm"].log_CateID.value=="") {
      alert("select category")
  	return false
     }
     return true
    }
   </script>
    <form name="frm" action="blogpost.asp" method="post" onsubmit="return chkFrm()">
      <div id="MsgContent" style="width:350px">
        <div id="MsgHead">post - select category</div>
        <div id="MsgBody">
          <table width="100%" border="0" cellpadding="3" cellspacing="0">
    <tr>
      <td width="100" align="right"><span style="font-weight: bold">select category of blogs:</span></td>
      <td align="left"><span style="font-weight: bold">
        <select name="log_CateID" id="select2">
          <option value="" selected="selected" style="color:#333">select category</option>
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
                If stat_ShowHiddenCate And stat_Admin Then Response.Write("<option value='"&Arr_Category(0, i)&"'>&nbsp;&nbsp;&nbsp;"&Arr_Category(1, i)&"&nbsp;["&Arr_Category(7, i)&"]&nbsp;&nbsp;</option>")
            Else
                Response.Write("<option value='"&Arr_Category(0, i)&"'>&nbsp;&nbsp;&nbsp;"&Arr_Category(1, i)&"&nbsp;["&Arr_Category(7, i)&"]&nbsp;&nbsp;</option>")
            End If
        End If
    Next
End Sub

%>
        </select>
      </span></td>
    </tr>
    <tr>
      <td align="right"><span style="font-weight: bold">select edit type:</span></td>
      <td align="left"><label title="UBB editor" for="ET1" accesskey="U"><input type="radio" id="ET1" name="log_editType" value="1" checked="checked" />UBBeditor</label>         <label title="FCK online editor" for="ET2" accesskey="K">
          <input name="log_editType" type="radio" id="ET2" value="0" />         
          FCKeditor</label></td>
    </tr>
    <tr>
    <td colspan="2" align="center"><input name="submit" type="submit" class="userbutton" value="下一步" accesskey="N"/> <input name="button" type="button" class="userbutton" value="back to homepage" onclick="location='default.asp'" accesskey="Q"/></td>
    </tr>
  </table>
  
  	  </div>
  	</div>
  </form>
  <%Else
    Dim log_editType, editTs
    log_editType = Request.Form("log_editType")

%>
  <!--second-->
    <form name="frm" action="blogpost.asp" method="post" onsubmit="return CheckPost()">
      		    <input name="log_CateID" type="hidden" id="log_CateID" value="<%=Request.Form("log_CateID")%>"/>
                <input name="log_editType" type="hidden" id="log_editType" value="<%=log_editType%>"/>
  				<input name="action" type="hidden" value="post"/>
                <input name="FirstPost" type="hidden" value="0"/>   
                <input name="postbackId" type="hidden" value="0"/>
                <input name="log_IsDraft" type="hidden" id="log_IsDraft" value="False"/>
  	<div id="MsgContent" style="width:630px;float:left; margin-left:20px;">
        <div id="MsgHead">at 【<%=Conn.ExeCute("SELECT cate_Name FROM blog_Category WHERE cate_ID="&Request.Form("log_CateID")&"")(0)%>】 post blog</div>
        <div id="MsgBody">
          <table width="100%" border="0" cellpadding="2" cellspacing="0">
            <tr>
              <td width="76" height="24" align="right" valign="top"><span style="font-weight: bold">title:</span></td>
              <td align="left"><input name="title" type="text" class="inputBox" id="title" size="50" maxlength="50"/>
              </td>
            </tr>
			<%If blog_postFile = 2 Then%>
			<tr>
              <td height="24" align="right" valign="top"><span style="font-weight: bold">mickname:</span></td>
              <td align="left">
			  <input name="cname" type="text" class="inputBox" id="titles" size="30" maxlength="50" onblur="check('Action.asp?action=checkAlias&Cname='+document.forms['frm'].cname.value,'CheckAlias','CheckAlias')" style="ime-mode:disabled"/>
			   <span> . </span>
			  <select name="ctype">
			    <option value="0">htm</option> 
				<option value="1">html</option>
			  </select> <span id="CheckAlias"></span>
              </td>
            </tr>
			<%end if%>
            <tr>
              <td align="right" valign="top"><span style="font-weight: bold">blog set:</span></td>
              <td align="left">
                <select name="log_weather" id="logweather">
                  <option value="sunny" selected="selected">sunny </option>
                  <option value="cloudy">cloudy </option>
                  <option value="flurries">windy </option>
                  <option value="ice">ice </option>
                  <option value="ptcl">bad </option>
                  <option value="rain">rainy </option>
                  <option value="showers">bad rainy </option>
                  <option value="snow">snowy </option>
                </select>
                <select name="log_Level" id="logLevel">
                  <option value="level1">★</option>
                  <option value="level2">★★</option>
                  <option value="level3" selected="selected">★★★</option>
                  <option value="level4">★★★★</option>
                  <option value="level5">★★★★★</option>
                </select>
                <label for="label">
                <input id="label" name="log_comorder" type="checkbox" value="1" checked="checked" />
        </label>
                <label for="label2">
                <input name="log_DisComment" type="checkbox" id="label2" value="1" />
        </label>
                <label for="label3">
                <input name="log_IsTop" type="checkbox" id="label3" value="1" />
        </label>
              </td>
            </tr>
			<tr>
               <td align="right" valign="top"><span style="font-weight: bold">private and Meta:</span></td>
               <td align="left"><div>
	 				<label for="Secret">
	                <input id="Secret" name="log_IsHidden" type="checkbox" value="1" onClick="document.getElementById('Div_Password').style.display=(this.checked)?'block':'none'" />
	        set private in blog</label>
	 				<label for="Meta">
	                <input id="Meta" name="log_Meta" type="checkbox" value="1" onclick="document.getElementById('Div_Meta').style.display=(this.checked)?'block':'none'" />
	        set Meta</label></div>
	                  <div id="Div_Password" style="display:none;" class="tips_body">
                          <label for="bpws1"><input id="bpws1" type="radio" name="log_pws" value="0" checked/><b>private blog</b></label> - only author and admin can view<br/>
                          <label for="bpws2"><input id="bpws2" type="radio" name="log_pws" value="1"/><b>secure blog</b></label> - need correct password
                          <br/>&nbsp;&nbsp;&nbsp;&nbsp;
                          <span style="font-weight: bold">password:</span>
                          <input onFocus="this.select();$('bpws2').checked='checked'" name="log_Readpw" type="password" id="log_Readpw" size="12" class="inputBox" title="this can be empty" />
                          <span style="font-weight: bold">password notice:</span>
                          <input onFocus="$('bpws2').checked='checked'" name="log_Pwtips" type="text" id="log_Pwtips" size="35" class="inputBox" title="this can be empty" />
                          <label for="bpws3"><input id="bpws3" name="log_Pwtitle" type="checkbox" value="1" checked="checked" />secure title</label>
                          <label for="bpws4"><input id="bpws4" name="log_Pwcomm" type="checkbox" value="1" />secure comments</label>
	                  </div>
	                  <div id="Div_Meta" style="display:none;" class="tips_body">
      	 				  - set Meta<br/>
		                  <span style="font-weight: bold">KeyWords&nbsp;&nbsp;:</span>
						  <input name="log_KeyWords" type="text" id="log_KeyWords" size="80" class="inputBox" title="input keywords" />
						  <br />
						  <span style="font-weight: bold">Description:</span>
						  <input name="log_Description" type="text" id="log_Description" size="80" class="inputBox" title="input Description" />
	                  </div>
				  </td>
             </tr>
            <tr>
              <td height="24" align="right" valign="top"><b>original:</b></td>
              <td align="left"><span style="font-weight: bold"></span>
                  <input name="log_From" type="text" id="log_From" value="this belongs to present web" size="12" class="inputBox" />
                  <span style="font-weight: bold">website:</span>
                  <input name="log_FromURL" type="text" id="log_FromURL" value="<%=siteURL%>" size="38" class="inputBox" />
                </td>
            </tr>
            <tr>
              <td height="24" align="right" valign="top"><span style="font-weight: bold">post time:</span></td>
              <td align="left">
                  <label for="P1"><input name="PubTimeType" type="radio" id="P1" value="now" size="12" checked/>current time</label> 
                  <label for="P2"><input name="PubTimeType" type="radio" id="P2" value="com" size="12" />set date:</label>
                  <input onfocus="this.select();$('P2').checked='checked'" name="PubTime" type="text" value="<%=DateToStr(now(),"Y-m-d H:I:S")%>" size="21" class="inputBox" /> (format:yyyy-mm-dd hh:mm:ss)
                </td>
            </tr>
            <tr>
              <td height="24" align="right" valign="top"><span style="font-weight: bold">Tags:</span></td>
              <td align="left">
                      <input name="tags" type="text" value="" size="50" class="inputBox" /> <img src="images/insert.gif" alt="insert used Tag" onclick="popnew('getTags.asp','tag','250','324')" style="cursor:pointer"/> 
               </td>
            </tr>
             <tr>
              <td  align="right" valign="top"><span style="font-weight: bold">contents:</span></td>
              <td align="center"><%
If log_editType = 0 Then
    Dim sBasePath
    sBasePath = "FCKeditor/"
    Dim oFCKeditor
    Set oFCKeditor = New FCKeditor
    oFCKeditor.BasePath = sBasePath
    oFCKeditor.Config("AutoDetectLanguage") = False
    oFCKeditor.Config("DefaultLanguage") = "zh-cn"
    oFCKeditor.Value = ""
    oFCKeditor.Height = "350"
    oFCKeditor.Create "Message"
Else
    UBB_TextArea_Height = "200px;"
    UBB_AutoHidden = False
    UBBeditor("Message")
End If

%></td>
            </tr>
            <tr>
              <td align="right" valign="top">&nbsp;</td>
               <td align="left">
  <%if log_editType<>0 then %>
               <label for="label4">
                <label for="label4"><input id="label4" name="log_disImg" type="checkbox" value="1" />
  </label>
                <label for="label5">
                <input name="log_DisSM" type="checkbox" id="label5" value="1" />
  </label>
                <label for="label6">
                <input name="log_DisURL" type="checkbox" id="label6" value="1" />
  </label>
                <label for="label7">
                <input name="log_DisKey" type="checkbox" id="label7" value="1" />
  </label>
  <%else%>
                <strong>[&nbsp;&nbsp;<a herf="#" onClick="GetLength();" style="cursor:pointer">statistical</a>&nbsp;&nbsp;|&nbsp;&nbsp;<a herf="#" onClick="SetContents();" style="cursor:pointer">contents clear</a>&nbsp;&nbsp;]</strong>
  <%end if%></td></tr>
          <tr>
              <td align="right" valign="top"><span style="font-weight: bold">content abstract:</span></td>
              <td align="left"><div><label for="shC"><input id="shC" name="log_IntroC" type="checkbox" value="1" onclick="document.getElementById('Div_Intro').style.display=(this.checked)?'block':'none'"/>edit abstract/label></div>
              <div id="Div_Intro" style="display:none">
              <%
If log_editType = 0 Then
    Dim oFCKeditor1
    Set oFCKeditor1 = New FCKeditor
    oFCKeditor1.BasePath = sBasePath
    oFCKeditor1.Height = "150"
    oFCKeditor1.ToolbarSet = "Basic"
    oFCKeditor1.Config("AutoDetectLanguage") = False
    oFCKeditor1.Config("DefaultLanguage") = "zh-cn"
    oFCKeditor1.Value = ""
    oFCKeditor1.Create "log_Intro"
Else

%>
  	         <textarea name="log_Intro" class="editTextarea" style="width:99%;height:120px;"></textarea>
  	         <%
End If

%></div>
              </td>
          </tr>          <tr>
              <td align="right" valign="top" nowrap><span style="font-weight: bold">upward file:</span></td>
              <td align="left"><iframe src="attachment.asp" width="100%" height="24" frameborder="0" scrolling="no" border="0" frameborder="0"></iframe></td>
            </tr>
            <tr>
              <td align="right" valign="top"><span style="font-weight: bold">use index:</span></td>
              <td align="left"><input name="log_Quote" type="text" size="80" class="inputBox" id="logQuote"/><br>input URL</td>
            </tr>
            <tr>
              <td colspan="2" align="center">
                <input name="SaveArticle" type="submit" class="userbutton" value="submit" accesskey="S"/>
                <input name="SaveDraft" type="submit" class="userbutton" value="save as draft" accesskey="D" onclick="document.getElementById('log_IsDraft').value='True'"/>
                <input name="ReturnButton" type="button" class="userbutton" value="back" accesskey="Q" onClick="history.go(-1)"/></td>
            </tr>
            <tr>
              <td colspan="2" align="right">
                </td>
            </tr>
           
           </table>
        </div>
  	</div>
  </form>
  <%
End If
End If
End If
Else
%>
   <div style="text-align:center;">
    <div id="MsgContent" style="width:300px">
      <div id="MsgHead">post error</div>
      <div id="MsgBody">
		 <div class="ErrorIcon"></div>
        <div class="MessageText">transfer data by other link is not allowed<br/><a href="default.asp">back to homepage</a>
		 <meta http-equiv="refresh" content="3;url=default.asp"/></div>
	  </div>
	</div>
  </div> 
  <%end if%><br/>
 </div> 
</div>
<!--#include file="plugins.asp" -->
<!--#include file="footer.asp" -->
