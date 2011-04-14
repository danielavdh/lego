var leonid={
	test: function(params){
		alert(params);
	},
	admin:{
		focus: function(id){
			if(document.getElementById(id)){
				document.getElementById(id).focus();
			}
		},
		visibleLessons: 1,
		showNextLesson: function(){
			if(leonid.admin.visibleLessons<10){
				document.getElementById("lesson"+leonid.admin.visibleLessons).style.display = "block";
				leonid.admin.visibleLessons++;
			}
		}
	},
	page: {
		setWidth: function(action){
			if(action=="index"){
				if(BrowserDetect.browser=="Explorer"){
					var width = document.body.clientWidth;
				}else{
					width = window.innerWidth;
				}
				document.getElementById("bkgImg").style.width = (width)+ "px";
				document.getElementById("page").style.width = (width)+ "px";
				document.getElementById("name_hand").style.left = (width*0.06)+ "px";
				document.getElementById("name_hand").style.top = (width*0.34)+ "px";
				document.getElementById("name_hand").style.fontSize = (width/512)+ "em";
				document.getElementById("play_links").style.right = (width*0.735)+ "px";
				document.getElementById("play_links").style.top = (width*0.11)+ "px";
				document.getElementById("play_links").style.fontSize = (width/1024)+ "em";
				document.getElementById("teach_links").style.left = (width*0.7)+ "px";
				document.getElementById("teach_links").style.top = (width*0.41)+ "px";
				document.getElementById("teach_links").style.fontSize = (width/1024)+ "em";
				var lists = document.getElementsByTagName("li");
				for(var i=0; i<lists.length; i++){
					lists[i].style.lineHeight = (width/34)+"px";
				}
			}
		},
		resizeText: function(){
			var allTags = document.getElementsByTagName("*");
			var allClasses = new Array(allTags.length);
			if(BrowserDetect.browser=="Explorer"){
				var width = document.body.clientWidth;
				for(i=0; i<allTags.length; i++){
					allClasses[i] = allTags[i].className;
				}
			}else{
				width = window.innerWidth;
				for(i=0; i<allTags.length; i++){
					allClasses[i] = allTags[i].getAttribute("class");
				}
			}
			for(j=0; j<allTags.length; j++){
				if(allClasses[j]=="flexi33" || allClasses[j]=="login_links"){
					allTags[j].style.fontSize = (width/1650) + "em";
				}else if(allClasses[j]=="flexi50"){
					allTags[j].style.fontSize = (width/1300) + "em";
				}else if(allClasses[j]=="flexi80" || allClasses[j]=="studentFields"){
					allTags[j].style.fontSize = (width/1150) + "em";
				}else if(allClasses[j]=="flexi100" || allClasses[j]=="project_links"){
					allTags[j].style.fontSize = (width/1024) + "em";
				}else if(allClasses[j]=="flexi120"){
					allTags[j].style.fontSize = (width/850) + "em";
				}
			}
		},
		resizeImg: function(action){
			if(action == "index"){
				if(BrowserDetect.browser=="Explorer"){
					var width = document.body.clientWidth;
					var height = document.body.clientHeight;
				}else{
					width = window.innerWidth;
					height = window.innerHeight;
				}
				document.getElementById("index_bkg_img").style.height = (0.84 * height) + "px";
				document.getElementById("index_bkg_img").style.width = (1.86 * 0.84 * height) + "px";
			}
		},
		/*resizeMovie: function(action){
			if(action == "recordings"){
				if(BrowserDetect.browser=="Explorer"){
					var width = document.body.clientWidth;
					var height = document.body.clientHeight;
				}else{
					width = window.innerWidth;
					height = window.innerHeight;
				}
			//1024 ==> 645  (124% of  movie height)
			//658 ==> 520  (80% of page height) (.78*658=513 ==> safe)
			leonid.movies.swfHeight = 0.78 * height;
			leonid.movies.swfWidth = leonid.movies.swfHeight * 1.24;
			}
		},*/
		toggleDisplay: function(elementId){
			element = document.getElementById(elementId);
			if(element.style.display=="none"){
				element.style.display = "block";
			}else{
				element.style.display = "none;"
			}
		},
		showScroller: function(){
			if(document.getElementById("scroller").style.display != "block"){
				document.getElementById("scroller").style.display = "block";
			}
		}
	},
	links:{
		show_page: function(action, color){
			if(action=="high_res_photos"){
				action = "photos";
				color = '#ccc6c6';
			}
			document.getElementById(action).style.backgroundColor = color;
		},
		show_project: function(action, color){
			document.getElementById(action).style.backgroundColor = color;
		}
	},
	movies: {
		movie: null,
		height: null,
		width: null,
		flashvars: {
		   xmlData: "",
		   videoInfoData: "",	/* put data in in database :)  */
		   mediaInfoData: "",  /*should replace videoInfoData!*/
           fileName: "",
           fileType: "",
           movieSize: "",
           screenRatio: ""
		},
		paramsOffWhite: {
		   quality: "high",
  		   wmode: "transparent",
  		   bgcolor: "#eeeeee",
		   allowScriptAccess: "sameDomain"
		},
		attr:{},
		mediaShow: function(elementId){
			if(elementId){
			  Effect.Appear(elementId,{ from: 0.0, to: 0.75, duration: 0.5 });
			}else{
			  Effect.Appear("mediaBlanket",{ from: 0.0, to: 0.75, duration: 0.5 });
			}
		},
		getReference: function(e){
			leonid.movies.movie = e.ref;
		},
		loadAudioPlayer: function(){
			swfobject.embedSWF("../audioPlayer.swf", "audioSWF", "500", "300", "9.0.115", false, leonid.movies.flashvars, leonid.movies.paramsOffWhite, leonid.movies.attr, leonid.movies.getReference);
		},
		unloadAudioPlayer:function(){
			leonid.movies.unloadBlanket();
			leonid.movies.movie.unloadAudio();
		},
		loadVideoPlayer: function(){
			swfobject.embedSWF("../mediaPlayer.swf", "videoSWF", "645", "520", "9.0.115", false, leonid.movies.flashvars, leonid.movies.paramsOffWhite, leonid.movies.attr, leonid.movies.getReference);
			//swfobject.embedSWF("../mediaPlayer.swf", "videoSWF", leonid.movies.swfWidth, leonid.movies.swfHeight, "9.0.115", false, leonid.movies.flashvars, leonid.movies.paramsOffWhite, leonid.movies.attr, leonid.movies.getReference);
		},
		unloadVideoPlayer:function(){
			if($('videoSWF')){
				leonid.movies.movie.removeListeners();
				swfobject.removeSWF('videoSWF');
			}
			leonid.movies.unloadBlanket();
		},
		unloadBlanket:function(){
			document.getElementById('mediaBlanket').style.display = "none";
		},
		accessLevel: null,
		hideEffect:function(accessLevel, category){
			if(accessLevel=="user"){
				if(category=="lgVid"){
					$('hstVideo').hide(); $('specialVideo').hide();
				}else if(category=="hstVid"){
					$('leonidVideo').hide(); $('specialVideo').hide();
				}else if(category=="seVid"){
					$('leonidVideo').hide(); $('hstVideo').hide(); 
				}else{
					$('leonidVideo').hide(); $('hstVideo').hide(); $('specialVideo').hide();
				}
			}else if(accessLevel=="friend"){
				if(category=="lgVid"){
					return "";
				}else if(category=="hstVid"){
					$('specialVideo').hide();
				}else if(category=="seVid"){
					$('hstVideo').hide();
				}else{
					$('hstVideo').hide(); $('specialVideo').hide();
				}
			}else{
				return "";
			}
		}
	},
	maps: {
		initialize: function(actionName, railsEnv, date){
			if(actionName == "classes"){ // otherwise IE prduces error on other teaching pages
				href = '/teaching/directions?class='+ date;
				address = "<a class='flexi100' href="+href+">print directions</a>";
      				if (GBrowserIsCompatible()) {
        				var map = new GMap2(document.getElementById("map_canvas"));
        				map.setCenter(new GLatLng(51.087025, 0.047769), 13);
        				map.setUIToDefault();
    					var point = new GLatLng(51.087025, 0.067769);
    					map.addOverlay(new GMarker(point));
						//map.openInfoWindow(point,
            		       //document.createTextNode("<a href='/teaching/directions?class=18_4_10'>print directions</a>"));
						map.openInfoWindowHtml(point, address);
    				}
			 }
    	},
		trish: null
	},
	scrollText: {
		showArticle: null,
		move: function(){
			var v1=arguments,v2=v1.length,v3='content_container',v4='content';
			var v5=leonid.scrollText.getElement401(v3),v6=leonid.scrollText.getElement401(v4);
			if (!v5){return;}
			if (v5.XAS1!=null){clearTimeout(v5.XAS1);}
			var v7=(v2>0)?parseInt(v1[0]):1;
			if (v7){
				var v8=(v2>1)?parseInt(v1[1]):1,v9=(v2>2)?parseInt(v1[2]):50,v10=(v2>3)?parseInt(v1[3]):1;
				var v11=new leonid.scrollText.getElement12(v3),v12=new leonid.scrollText.getElement12(v4);
				var v13=v12.x,v14=v12.y,v15=0,v16=0;
				if (v10==1){
					var v17=-1*v12.h;v15=v12.x;
					if (v14>=v17)
					{v16=v12.y-v8;}
					else
					{v16=v11.h;}
				}
				else{
					var v18=-1*v12.w;v16=v12.y;
					if (v13>=v18)
					{v15=v12.x-v8;}
					else
					{v15=v11.w;}
				}
				leonid.scrollText.getElement10(v6,v15,v16);
				v5.XAS1=setTimeout("leonid.scrollText.move("+v7+","+v8+","+v9+","+v10+")",v9);
			}
		},
		getElement401: function(n,d){
  			var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
  			  d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  			if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  			for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=leonid.scrollText.getElement401(n,d.layers[i].document);
  			if(!x && d.getElementById) x=d.getElementById(n); return x;
		},
		getElement12: function(v1){
			var v2=leonid.scrollText.getElement401(v1);if (!v2){this.x=this.y=this.h=this.w=0;return;}var v3,v4,v5,v6,v7=(document.layers)?v2:v2.style;v3=isNaN(parseInt(v7.left))?v2.offsetLeft:parseInt(v7.left);v4=isNaN(parseInt(v7.top))?v4=v2.offsetTop:parseInt(v7.top);if (v2.offsetHeight){v5=v2.offsetHeight;v6=v2.offsetWidth;}else if (document.layers){v5=v7.clip.height;v6=v7.clip.width;}else {v5=v6=0;}this.x=parseInt(v3);this.y=parseInt(v4);this.h=parseInt(v5);this.w=parseInt(v6);
		},
		getElement10: function(v1,v2,v3){
			var v4=(document.layers)?v1:v1.style;
			var v5=leonid.scrollText.getElement10ua();
			var topValInt = eval(v4.top.substr(0, v4.top.length-2));
			var scrollContentHeight = leonid.scrollText.getElement401("content").clientHeight;
			var scrollContainerHeight = leonid.scrollText.getElement401("content_container").clientHeight;
			var positiveTopValInt = Math.abs(topValInt);
			if (!(positiveTopValInt > 0))
				positiveTopValInt  = 0;
			var scrollingUp = v3 > topValInt;
			if ((scrollingUp == false && positiveTopValInt < (scrollContentHeight - scrollContainerHeight)  ) || (scrollingUp == true &&  topValInt < 0))
			{
				eval("v4.left='"+v2+v5+"'");eval("v4.top='"+v3+v5+"'");
			}
		},
		getElement10ua: function(){
			var v1=((parseInt(navigator.appVersion)>4||navigator.userAgent.indexOf("MSIE")>-1)&&(!window.opera))?"px":"";return v1;
		}
	}
}
