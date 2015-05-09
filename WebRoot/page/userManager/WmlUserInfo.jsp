<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" >
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>客户管理</title>
<LINK REL="SHORTCUT ICON" HREF="<%=basePath%>images/logo.png">
<link rel="stylesheet" type="text/css" href="<%=basePath%>js/jquery-easyui-1.3.5/themes/default/easyui.css">
<link rel="stylesheet" type="text/css" href="<%=basePath%>js/jquery-easyui-1.3.5//themes/icon.css">
<script type="text/javascript" src="<%=basePath%>js/jquery-1.4.4.min.js"></script>
<script type="text/javascript" src="<%=basePath%>js/jquery-easyui-1.3.5/jquery.easyui.min.js"></script>
<jsp:include page="../../common/gtGridHead.jsp" />
<style type="text/css">
.gt-row-selected td {
	background-color: #004da8;
	color: #ffffff;
}
</style>
<script type="text/javascript">

	var mygrid = null;
	var jsonVal="";

	
	var statusOpt={};
	statusOpt["0"] = "待审核";
	statusOpt["1"] = "正常";
	statusOpt["2"] = "禁用";
	
	var typeOpt={};
	typeOpt["0"] = "用户";
	typeOpt["1"] = "操作员";
	typeOpt["2"] = "拥有商户者";
	typeOpt["3"] = "游客";
	
	var channelOpt={};
	channelOpt["0"] = "QQ";
	channelOpt["1"] = "微博";
	channelOpt["2"] = "微信";
	channelOpt["3"] = "手机端";
	
	var permiOpt={};
	permiOpt["0"] = "是";
	permiOpt["1"] = "否";
	
	
		var grid_demo_id = "myGrid1";

		var dsConfig = {
			fields : [ 
			           {name : 'id',type : 'text'}, 
					   {name : 'createDate',type : 'text'}, 
					   {name : 'uid',type : 'int'},
					   {name : 'uidName',type : 'text'},
					   {name : 'lastDate',type : 'text'},
					   {name : 'signature',type : 'text'},
					   {name : 'loginName',type : 'text'},
					   {name : 'name',type : 'text'},
					   {name : 'password',type : 'text'},
					   {name : 'phone',type : 'float'},
					   {name : 'head',type : 'text'},
					   {name : 'type',type : 'text'},
					   {name : 'organ',type : 'int'},
					   {name : 'organName',type : 'text'},
					   {name : 'permissions',type : 'int'},
					   {name : 'channel',type : 'int'},
					   {name : 'uploadFlag',type : 'text'},
					   {name : 'status',type : 'int'},
					   {name : 'isDel',type : 'int'}
					  ]};

		var colsConfig = [  
			{id : 'id',header : "编号",width : 50},
			{id : 'organName',header : "所属商户",width : 60},
			{id : 'loginName',header : "登录帐号",width : 100},
			{id : 'name',header : "用户名",width : 100},
			{id : 'phone',header : "手机",width : 90},
			{id : 'signature',header : "个性签名",width : 120},
			{id : 'status',header : "状态",width : 40,renderer : GT.Grid.mappingRenderer(statusOpt, '')},
			{id : 'channel',header : "登录类型",width : 60,renderer : GT.Grid.mappingRenderer(channelOpt, '')},
			{id : 'type',header : "用户类型",width : 70,renderer : GT.Grid.mappingRenderer(typeOpt, '')},
			{id : 'permissions',header : "免审批",width : 50,renderer : GT.Grid.mappingRenderer(permiOpt, '')},
			{id : 'lastDate',header : "最近登录时间",width :90},
			{id : 'createDate',header : "创建时间",width :80},
			{id : 'uidName',header : "推荐人",width : 50},
			{id : 'detail' , header : "详细信息" , width : 70,
				renderer : function(value ,record,columnObj,grid,colNo,rowNo){
					
					return "<u onclick=showSellDetail('"+record['id']+"')>点击查看</u>";
					
				}}
			];

		var gridConfig = {
			id : grid_demo_id,
			loadURL : "wmlUser_queryWmlUserPage.action",
			dataset : dsConfig,
			columns : colsConfig,
			container : 'grid1_container',
			toolbarPosition : 'bottom',
			toolbarContent : 'nav | goto | pagesize | state',
			pageSize : 19,
			pageSizeList : [ 20, 40, 80, 100 ],
			onCellDblClick : function(value, record , cell,row, colNO, rowNO,column,event){
				jsonVal=JSON.stringify(record);
				var sheight = screen.height * 0.6;
				var swidth = screen.width * 0.55;
				var iTop = (window.screen.availHeight-30-sheight)/2; 
				var iLeft = (window.screen.availWidth-10-swidth)/2; 
				var url = "<%=basePath%>page/userManager/WmlUserUpdate.jsp";
				window.open(url,null,'height='+sheight+'px,width='+swidth+'px,top='+iTop+'px,left='+iLeft+'px,toolbar=no,menubar=no,scrollbars=no,resizable=no,location=no,status=no');
		}
		};

		
	

	$(function() {
		mygrid=new GT.Grid( gridConfig );
		mygrid.render();
	});

	function query(e) {
		var theEvent = e || window.event;
		var code = theEvent.keyCode || theEvent.which || theEvent.charCode;
		if (code == 13) {
			queryAuto();
		}
	}
	
	function queryAuto() {
		
		var userId = $("#userId").val();
		var loginName = $("#loginName").val();
		var channel = $("#channel").val();
		var status = $("#status").val();
		var uid = $("#uid").val();
		var startDate=$("#startDate").val();
		var endDate=$("#endDate").val();
		
		if(startDate!="" && endDate!=""){
			if(startDate<endDate){
		mygrid.query( {
			'wmlUser.id' :userId,
			'wmlUser.loginName' :loginName,
			'wmlUser.channel' :channel,
			'wmlUser.status' :status,
			'wmlUser.uid' :uid,
			'wmlUser.createDate' :startDate,
			'wmlUser.endDate' :endDate
		});
		}else{
			alert("开始时间不能大于结束时间!");
		}
		}else{
		mygrid.query( {
			'wmlUser.id' :userId,
			'wmlUser.loginName' :loginName,
			'wmlUser.channel' :channel,
			'wmlUser.status' :status,
			'wmlUser.uid' :uid,
		});
		}
	}


	function add() {
		var sheight = screen.height * 0.5;
		var swidth = screen.width * 0.4;
		var iTop = (window.screen.availHeight-30-sheight)/2; 
		var iLeft = (window.screen.availWidth-10-swidth)/2; 
		var url = "<%=basePath%>page/userManager/WmlUserAdd.jsp";
		window.open(url, null,'height='+sheight+'px,width='+swidth+'px,top='+iTop+'px,left='+iLeft+'px,toolbar=no,menubar=no,scrollbars=no,resizable=no,location=no,status=no');
		mygrid.reload();
	}
	function showSellDetail(userId){
		var sheight = screen.height * 0.8;
		var swidth = screen.width * 0.8;
		var iTop = (window.screen.availHeight-30-sheight)/2; 
		var iLeft = (window.screen.availWidth-10-swidth)/2; 
		var url = "wmlUser_queryUserDetail.action?wmlUser.id="+userId;
		window.open(url, null,'height='+sheight+'px,width='+swidth+'px,top='+iTop+'px,left='+iLeft+'px,toolbar=no,menubar=no,scrollbars=no,resizable=no,location=no,status=no');
		
	}
</script>
</head>
<body>
<div id="tt" class="easyui-tabs"  style="height: 570px;">
	<div title="客户管理" class="gt-panel" >
		<div>
			<table>
				<tr>
				<td>编号：</td>
					<td style="width: 50px;"><input style="width: 50px;" type="text" name="userId" id="userId"
						onkeydown="query(event)"></td>
					<td>登录帐号：</td>
					<td style="width: 110px;"><input style="width: 100px;" type="text" name="loginName" id="loginName"
						onkeydown="query(event)"></td>
						<td>登录类型：</td>
					<td style="width: 80px;"> <select id="channel">
						<option value=" ">全选</option>
						<option value="0">QQ</option>
						<option value="1">微博</option>
						<option value="2">微信</option>
						<option value="3">手机端</option>
					</select>	</td>
						<td>状态：</td>
					<td style="width: 80px;"> <select id="status">
						<option value=" ">全选</option>
						<option value="0">待审核</option>
						<option value="1">正常</option>
						<option value="2">禁用</option>
					</select></td>
						<td>推荐人ID：</td>
					<td style="width: 110px;"><input style="width: 100px;" type="text" name="uid" id="uid"	onkeydown="query(event)"></td>
						<td>开始时间：</td>
					<td ><input style="width: 80px;" type="text" name="startDate" id="startDate"onclick="timeSelect('startDate',null)" /></td>
						<td>结束时间：</td>
					<td><input style="width: 80px;" type="text" name="endDate" id="endDate" onclick="timeSelect('endDate',null)" /></td>
				</tr>
			</table>
		</div>
		<div class="gt-button-area">
			<input type="button" class="gt-input-button" value="添加" onclick="add()" /> 
			<input type="button" class="gt-input-button" value="查询" onclick="queryAuto()" /> 
		</div>
		<!-- grid的容器. -->
		<div id="grid1_container" style="width: 99%; height: 88%;"></div>		
	</div>
</div>
</body>
</html>