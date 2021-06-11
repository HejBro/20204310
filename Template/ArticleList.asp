<%ST(A)%><$log_Author$><%ST(A)%><$log_viewCount$><%ST(A)%>
		<div class="Content">
			<div class="Content-top"><div class="ContentLeft"></div><div class="ContentRight"></div>
				 <$ShowButton$>
				 <h1 class="ContentTitle"><img src="<$Cate_icon$>" style="margin:0px 2px -4px 0px;" alt="" class="CateIcon"/><a class="titleA" href="<$log_ceeurl$>"><$log_Title$></a><$log_hiddenIcon$>[<a href="default.asp?cateID=<$log_CateID$>" title=""><$Cate_Title$></a>]</h1>
				 <h2 class="ContentAuthor">author:<$log_Author$> date:<$log_PostTime$></h2>
			</div>
			<div id="log_<$LogID$>"<$ShowStyle$>>
				<div class="Content-body">
					 <$log_Intro$>
					 <$log_readMore$>
				</div>
				<div class="Content-bottom">
					 <div class="ContentBLeft"></div>
					 <$log_tag$>
					 <p><a href="?id=<$LogID$>">solid link</a> | <a href="<$log_ceeurl$>#comm_top">comments: <$log_CommNums$></a> | <a href="trackback.asp?tbID=<$LogID$>&amp;action=view" target="_blank">index: <$log_QuoteNums$></a> | viewed times: <$log_viewC$><$editRight$></p>
					 <div class="ContentBRight"></div>
			    </div>
			</div>
		</div>
	<%ST(A)%>
		<tr>
			<td valign="top">
			    <a href="default.asp?cateID=<$log_CateID$>" ><img border="0" alt="view <$Cate_Title$> " src="<$Cate_icon$>" style="margin:0px 2px -3px 0px"/></a>
				<a href="<$log_ceeurl$>" title="author:<$log_Author$> date:<$log_PostTime$>"><$log_Title$></a><$log_hiddenIcon$>
			</td>
			<td valign="top" width="60"><nobr><a href="<$log_ceeurl$>#comm_top" title="comments"><$log_CommNums$></a> | <a href="trackback.asp?tbID=<$LogID$>&amp;action=view" target="_blank" title="use notice"><$log_QuoteNums$></a> | <span title="viewed times"><$log_viewC$></span></nobr></td>
		</tr>
   <%ST(A)%>
		<div class="Content">
			<div class="Content-top"><div class="ContentLeft"></div><div class="ContentRight"></div>
				 <$ShowButton$>
				 <h1 class="ContentTitle"><img src="<$Cate_icon$>" style="margin:0px 2px -4px 0px;" alt="" class="CateIcon"/><a class="titleA" href="<$log_ceeurl$>"><$Show_Title$></a><$log_hiddenIcon$>[<a href="default.asp?cateID=<$log_CateID$>" title=""><$Cate_Title$></a>]</h1>
				 <h2 class="ContentAuthor">author:<$log_Author$> date:<$log_PostTime$></h2>
			</div>
			<div id="log_<$LogID$>"<$ShowStyle$>>
				<div class="Content-body">
					 <$log_Secret$>
				</div>
				<div class="Content-bottom">
					 <div class="ContentBLeft"></div>
					 <p><a href="?id=<$LogID$>">solid link</a> | <a href="<$log_ceeurl$>#comm_top">comments: <$log_CommNums$></a> | <a href="trackback.asp?tbID=<$LogID$>&amp;action=view" target="_blank">use index: <$log_QuoteNums$></a> | use times: <$log_viewC$><$editRight$></p>
					 <div class="ContentBRight"></div>
			    </div>
			</div>
		</div>
   <%ST(A)%>
		<tr>
			<td valign="top">
			    <a href="default.asp?cateID=<$log_CateID$>" ><img border="0" alt="view <$Cate_Title$> " src="<$Cate_icon$>" style="margin:0px 2px -3px 0px"/></a>
				<a href="<$log_ceeurl$>" title="author:<$log_Author$> date:<$log_PostTime$>"><$Show_Title$></a><$log_hiddenIcon$>
			</td>
			<td valign="top" width="60"><nobr><a href="<$log_ceeurl$>#comm_top" title="comments"><$log_CommNums$></a> | <span title="use notice"><$log_QuoteNums$></span> | <span title="viewed times"><$log_viewC$></span></nobr></td>
		</tr>