<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>
<%
		if(request.getParameter("scheduleNo") == null){
			response.sendRedirect("./scheduleList.jsp");
			return;
		}
	//schedule No 받아서 변수에 저장하기
	int scheduleNo = Integer.parseInt(request.getParameter("scheduleNo"));
	//DB연동하는 코드
	//드라이버 로딩
	Class.forName("org.mariadb.jdbc.Driver");
	//디버깅체크~
	System.out.println("scheduleOne 드라이버 로딩 성공했어");
	//마리아 디비 연결 유지해줍니다.
	Connection conn = null;
	System.out.println("접속 확인"+conn);
	conn = DriverManager.getConnection( //마리아 디비 가져오기
			"jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
	//sql변수에 쿼리 값 저장
	String sql = "select schedule_no scheduleNo, schedule_date scheduleDate, schedule_time scheduleTime, schedule_memo scheduleMemo, schedule_color scheduleColor, createdate,updatedate from schedule where schedule_no = ?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1, scheduleNo);
	System.out.println(stmt + " <-- scheduleOne stmt"); 
	ResultSet rs = stmt.executeQuery(); 
	
	ArrayList<Schedule> scheduleList = new ArrayList<Schedule>();
	while(rs.next()){
		Schedule s = new Schedule(); //rs 의 개수만큼 만들어줌
		s.scheduleNo = rs.getInt("scheduleNo");
		s.scheduleDate = rs.getString("scheduleDate");
		s.scheduleTime = rs.getString("scheduleTime");// 쿼리에서 날짜만 가져옴으로써 날짜값만 들어온다. day(schedule_date) scheduleDate
		s.scheduleMemo = rs.getString("scheduleMemo"); //subString을 활용해서 전체가 아닌 설정값만 들어온다.
		s.scheduleColor = rs.getString("scheduleColor");
		s.createdate = rs.getString("createdate");
		s.updatedate = rs.getString("updatedate");
		
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
	</style>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
        <meta name="description" content="" />
        <meta name="author" content="" />
        <title>scheduleOne</title>
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
                <h1 class="text-white fs-3 fw-bolder">스케줄 상세보기</h1>
            </div>
        </header>
        <!-- Content section-->
        <section class="py-5">
            <div class="container my-5">
                <div class="row justify-content-center">
                    <div class="col-lg-6">
                     	<%
							for(Schedule s : scheduleList){
						%>
							<table class="table">
								<tr>
									<td>스케줄번호</td>
									<td><%=s.scheduleNo%></td>
								</tr>
								<tr>
									<td>스케줄날짜</td>
									<td><%=s.scheduleDate%></td>
								</tr>
								<tr>
									<td>시간</td>
									<td><%=s.scheduleTime%></td>
								</tr>
								<tr>
									<td>메모</td>
									<td><%=s.scheduleMemo%></td>
								</tr>
								<tr>
									<td>색상</td>
									<td><%=s.scheduleColor%></td>
								</tr>
								<tr>
									<td>만든날</td>
									<td><%=s.createdate%></td>
								</tr>
								<tr>
									<td>수정날</td>
									<td><%=s.updatedate%></td>
								</tr>
							</table>
						<%		
							}
						%>
						<div>
							<a href="./updateScheduleForm.jsp?scheduleNo=<%=scheduleNo%>" class="btn btn-outline-dark">수정</a> <!--  물음표 뒤에 있는 값을 보내준다 -->
							<a href="./deleteScheduleForm.jsp?scheduleNo=<%=scheduleNo%>" class="btn btn-outline-dark">삭제</a> <!--  물음표 뒤에 있는 값을 보내준다 -->
						</div>
					 </div>
                </div>
            </div>
        </section>
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
