<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>
<%
	int targetYear = 0;
	int targetMonth = 0;
	// 년 or 월이 요청값에 넘어오지 않으면 오늘 날짜의 년/월 값으로 
	if(request.getParameter("targetYear") == null || (request.getParameter("targetMonth") == null)) {
		Calendar c = Calendar.getInstance();
		targetYear = c.get(Calendar.YEAR);
		targetMonth = c.get(Calendar.MONTH);
	}else {
		targetYear = Integer.parseInt(request.getParameter("targetYear"));
		targetMonth = Integer.parseInt(request.getParameter("targetMonth"));
	}
	System.out.println(targetYear+"<-- scheduleList param targetYear");		
	System.out.println(targetMonth+"<-- scheduleList param targetMonth");
	
	// 오늘 날짜 구하기
	
	Calendar today = Calendar.getInstance();
	int todatDate = today.get(Calendar.DATE);
	
	// targetMonth 1일의 요일을 알고싶다
	
	Calendar firstDay = Calendar.getInstance(); // 2023 4 24
	firstDay.set(Calendar.YEAR, targetYear);// 년도 바꿔주는식
	firstDay.set(Calendar.MONTH, targetMonth);// 월 바꿔주는 식
	firstDay.set(Calendar.DATE, 1); // 2023 04 01 설정을 1일로 바꿔주는 식
	
	Calendar preMonth = Calendar.getInstance();
	preMonth.set(Calendar.YEAR, targetYear);
	preMonth.set(Calendar.MONTH, targetMonth -1);
	int preLastDate = preMonth.getActualMaximum(Calendar.DATE);
	System.out.println(preLastDate+"<-- 전달마지막날짜");
	
	
	//Calendar API가 년도가 바뀔때 월이나 년도를 변경해주는 것을 targetYear 이나 targetMonth 변수에 저장하기
	targetYear = firstDay.get(Calendar.YEAR);
	targetMonth = firstDay.get(Calendar.MONTH);
	
	System.out.println(targetYear+"<-- api 적용한 scheduleList param targetYear");		
	System.out.println(targetMonth+"<-- api 적용한 scheduleList param targetMonth");
	
	int firstYoil = firstDay.get(Calendar.DAY_OF_WEEK); // 2023 04 01 1일이 몇번째 요일인지 구해주는 식 ex) 일 1, 토 7
	// 1일앞의 공백칸의 수
	System.out.println(firstYoil+"<--firstYoil");
	 int startBlank = firstYoil - 1;
	 System.out.println(startBlank+"<--startBlank");
	// targetMonth 마지막일 타켓 달의 날짜의 최고 숫자를 구하는 식
	int lastDate = firstDay.getActualMaximum(Calendar.DATE);
	System.out.println(lastDate+"<--lastDate");
	//전체 TD의 7의 나머지값은 0
	// lastDate날짜 뒤 공백칸의 수 구하기
	int endBlank = 0;
	if((startBlank+lastDate) % 7 != 0){
		 endBlank = 7 -(startBlank+lastDate)%7;
	}
	System.out.println(endBlank+"<--endBlank");
	// 전체 TD의 개수
	int totalTD = startBlank + lastDate + endBlank;
	System.out.println(totalTD+"<--totalTD");
	
	//DB date를 가져오는 알고리즘 
	
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection(
			"jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
	/* 
		select 
			schedule_no scheduleNo, 
			month(schedule_date) scheduleDate 
			substr(schedule_memo, 1, 5 ) scheduleMemo, 
			schedule_color scheduleColor 
		from schedule where year(schedule_date) = ? and month(schedule_date)= ? 
		order by month(schedule_date) asc;
	*/
	PreparedStatement stmt = conn.prepareStatement("select schedule_no scheduleNo, day(schedule_date) scheduleDate, substr(schedule_memo, 1, 5 ) scheduleMemo, schedule_color scheduleColor from schedule where year(schedule_date) = ? and month(schedule_date)= ? order by month(schedule_date) asc");  
	stmt.setInt(1, targetYear);
	stmt.setInt(2, targetMonth + 1);
	System.out.println(stmt + " <-- stmt");
	ResultSet rs = stmt.executeQuery();
	// ResultSet -> ArryList<Schedule>
	ArrayList<Schedule> scheduleList = new ArrayList<Schedule>();
	while(rs.next()){
		Schedule s = new Schedule(); //rs 의 개수만큼 만들어줌
		s.scheduleNo = rs.getInt("scheduleNo");
		s.scheduleDate = rs.getString("scheduleDate"); // 쿼리에서 날짜만 가져옴으로써 날짜값만 들어온다. day(schedule_date) scheduleDate
		s.scheduleMemo = rs.getString("scheduleMemo"); //subString을 활용해서 전체가 아닌 설정값만 들어온다.
		s.scheduleColor = rs.getString("scheduleColor");
		scheduleList.add(s);
	}
	
	
%>
<!DOCTYPE html>
<html lang="en">
    <head>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
	<!-- Latest compiled JavaScript -->
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
    <style type="text/css">
		.glanlink {color: #000000;}
		td { height : 200px; width: 400px;}
	</style>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
        <meta name="description" content="" />
        <meta name="author" content="" />
        <title>scheduleList</title>
        <!-- Favicon-->
        <link rel="icon" type="image/x-icon" href="./Resources/assets/favicon.ico" />
        <!-- Core theme CSS (includes Bootstrap)-->
        <link href="./Resources/css/styles.css" rel="stylesheet" />
    </head>
    <body>
        <!-- Responsive navbar-->
        <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
            <div class="container">
                <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation"><span class="navbar-toggler-icon"></span></button>
                <div class="collapse navbar-collapse" id="navbarSupportedContent">
                    <ul class="navbar-nav ms-auto mb-2 mb-lg-0">
                        <li class="nav-item"><a class="nav-link active" aria-current="page" href="home.jsp">Home</a></li>
                        <li class="nav-item"><a class="nav-link" href="./noticeList.jsp">공지 리스트</a></li>
                        <li class="nav-item"><a class="nav-link" href="./scheduleList.jsp">일정 리스트</a></li>
                    </ul>
                </div>
            </div>
        </nav>
        <!-- Header - set the background image for the header in the line below-->
        <header class="py-5 bg-image-full" style="background-image: url('https://source.unsplash.com/wfh8dDlNFOk/1600x900')">
            <div class="text-center my-5">
                <img class="img-fluid rounded-circle mb-4" src="./imges/schedule.jpg" alt="..." style="width: 150px; height: 150px;"/>
                <h1 class="text-white fs-3 fw-bolder"><%=targetYear%>년<%=targetMonth+1%>월</h1>
                <p class="text-white-50 mb-0">
              			<a href = "./scheduleList.jsp?targetYear=<%=targetYear%>&targetMonth=<%=targetMonth-1%>" class="btn btn-dark">이전달</a>
						<a href = "./scheduleList.jsp?targetYear=<%=targetYear%>&targetMonth=<%=targetMonth+1%>" class="btn btn-dark">다음달</a>
				</p>
            </div>
        </header>
        <!-- Content section-->
       
                     <table class="table" style="margin-bottom: 0;">
								<thead>
									<tr class="table-dark">
										<th>일</th>
										<th>월</th>
										<th>화</th>
										<th>수</th>
										<th>목</th>
										<th>금</th>
										<th>토</th>
									</tr>
								</thead>
								<tr>
								<%
								
								
									for(int i=0; i<totalTD; i+=1){
										
										int num= i-startBlank+1;
									
										if(i!=0 && i%7 == 0){
								%>
										</tr><tr>
								<% 			
										
										}
										String tdStyle = "";
										if(num>0 && num<=lastDate){
											//오늘 날짜이면
											if(today.get(Calendar.YEAR) == targetYear
												&& today.get(Calendar.MONTH) == targetMonth 
												&& today.get(Calendar.DATE) == num) {
												tdStyle = "background-color:gray;";
												}
								%>
												<td style="<%=tdStyle%>">
													<div><!-- 날짜 숫자 -->
													<a  class="glanlink" href="./scheduleListByDate.jsp?y=<%=targetYear%>&m=<%=targetMonth%>&d=<%=num%>"><%=num %></a>
													</div>
													<div><!-- 일정 memo 5글자만 나오게하는 디아브이 -->
														<%
															for(Schedule s : scheduleList){
																if(num == Integer.parseInt(s.scheduleDate)){
														%>
																	<div style="color:<%=s.scheduleColor%>"><%=s.scheduleMemo%></div>
														<% 		
																}
															}
														%>
													</div>
												</td>
								<% 
											
										}else if (num < 1) {
								%>
											<td class="text-secondary"><%= preLastDate - startBlank+ i +1 %></td>
								<%			
										}else{
								%>			
											<td class="text-secondary"><%= i - lastDate - startBlank + 1 %></td>
								<% 		
										}
									}
								%>
							</tr>
						</table>
					
        <!-- Image element - set the background image for the header in the line below-->
        <div class="py-5 bg-image-full" style="background-image: url('https://source.unsplash.com/4ulffa6qoKA/1200x800')">
            <!-- Put anything you want here! The spacer below with inline CSS is just for demo purposes!-->
            <div style="height: 20rem"></div>
        </div>
        <!-- Content section-->
        
        <!-- Footer-->
        <footer class="py-5 bg-dark">
            <div class="container"><p class="m-0 text-center text-white">GDJ66 &copy; KWJ 2023</p></div>
        </footer>
        <!-- Bootstrap core JS-->
        <script src="https:./Resources/js/bootstrap.bundle.min.js"></script>
        <!-- Core theme JS-->
        <script src="js/scripts.js"></script>
    </body>
</html>
