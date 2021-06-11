        <%ST(A)%>
			<div id="Content_ContentList" class="content-width"><a name="body" accesskey="B" href="#body"></a>
				<div class="pageContent">
					<div style="float:right;width:auto"><$log_Navigation$></div> 
					<img src="<$Cate_icon$>" style="margin:0px 2px -4px 0px" alt=""/> <strong><a href="default.asp?cateID=<$log_CateID$>" title="view all of【<$Cate_Title$>】"><$Cate_Title$></a></strong> <a href="feed.asp?cateID=<$log_CateID$>" target="_blank" title="subscribe all of【<$Cate_Title$>】" accesskey="O"><img border="0" src="images/rss.png" alt="subscribe all of【<$Cate_Title$>】" style="margin-bottom:-1px"/></a>
				</div>
				<div class="Content">
					<div class="Content-top"><div class="ContentLeft"></div><div class="ContentRight"></div>
					<h1 class="ContentTitle"><strong><$log_Title$></strong><$log_hiddenIcon$></h1>
					<h2 class="ContentAuthor">author:<$log_Author$> date:<$log_PostTime$></h2>
				</div>
			    <div class="Content-Info">
					<div class="InfoOther">font size: <a href="javascript:SetFont('12px')" accesskey="1">small</a> <a href="javascript:SetFont('14px')" accesskey="2">medium</a> <a href="javascript:SetFont('16px')" accesskey="3">big</a></div>
					<div class="InfoAuthor"><img src="images/weather/hn2_<$log_weather$>.gif" style="margin:0px 2px -6px 0px" alt=""/><img src="images/weather/hn2_t_<$log_weather$>.gif" alt=""/> <img src="images/<$log_level$>.gif" style="margin:0px 2px -1px 0px" alt=""/><$EditAndDel$></div>
				</div>
				<div id="logPanel" class="Content-body">
					<$ArticleContent$>
					<br/><br/>
				</div>
				<div class="Content-bottom">
					<div class="ContentBLeft"></div>
					<p><$log_Modify$></p>
					<p><img src="images/From.gif" style="margin:0px 2px -4px 0px" alt=""/><strong>blog from:</strong> <a href="<$log_FromUrl$>" target="_blank"><$log_From$></a></p>
					<p><img src="images/icon_trackback.gif" style="margin:4px 2px -4px 0px" alt=""/><strong>use notice:</strong> <a href="trackback.asp?tbID=<$LogID$>&amp;action=view" target="_blank">view all index</a> | <a href="javascript:;" title="get links of articles" onclick="getTrackbackURL(<$LogID$>)">i will use this article</a></p>
					<p><img src="images/tag.gif" style="margin:4px 2px -4px 0px" alt=""/><strong>Tags:</strong> <$log_tag$></p>
					<p><img src="images/notify.gif" style="margin:4px 2px -4px 0px" alt=""/><strong>relevant blogs:</strong>
					<div class="Content-body" id="related_tag" style="margin-left:25px"></div>
					<script language="javascript" type="text/javascript">check('Getarticle.asp?id=<$LogID$>&blog_postFile=1','related_tag','related_tag')</script></p>
					<p>comments: <$log_CommNums$> | <a href="trackback.asp?tbID=<$LogID$>&amp;action=view" target="_blank">index: <$log_QuoteNums$></a> | viewed times: <$log_ViewNums$></p>
					<div class="ContentBRight"></div>
					<br/><br/>
				</div>
			</div>
		</div>
