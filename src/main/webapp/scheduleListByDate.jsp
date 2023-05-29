<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>
<%
			//요청값 유효성 검사
	if(request.getParameter("y") == null 
			|| request.getParameter("m") == null
			|| request.getParameter("d") == null
			|| request.getParameter("y").equals("")
			|| request.getParameter("m").equals("")
			|| request.getParameter("d").equals("")			
			) {
		response.sendRedirect("./scheduleList.jsp");
		return; // 페이지 멈춰!
	}

		// y, m, d 값이 null or "" -> redirection scheduleList.jsp
		
		int y = Integer.parseInt(request.getParameter("y"));
		// 자바API는 12월은 11로 표현되고, 마리아디비에서는 12월을 12로 표현된다.
		int m = Integer.parseInt(request.getParameter("m")) + 1;
		int d = Integer.parseInt(request.getParameter("d"));
		
		System.out.println(y + "<-- scheduleListByDate 파라메라 Y값");
		System.out.println(m + "<-- scheduleListByDate 파라메라 m값");
		System.out.println(d + "<-- scheduleListByDate 파라메라 d값");
		
		String strM = m+"";
		if(m<10) {
			strM = "0"+strM;
		}
		String strD = d+"";
		if(d<10) {
			strD = "0"+strD;
		}
		//일별 스케줄리스트
		//DB연동하는 코드
		//드라이버 로딩
		Class.forName("org.mariadb.jdbc.Driver");
		//디버깅체크~
		System.out.println("드라이버 로딩 성공했어");
		//마리아 디비 연결 유지해줍니다.
		Connection conn = DriverManager.getConnection(
				"jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
		System.out.println("접속 확인"+conn);
		//sql변수에 쿼리 값 저장
		String sql = "select schedule_no scheduleNo, schedule_date scheduleDate, schedule_time scheduleTime, schedule_memo scheduleMemo, schedule_color scheduleColor, createdate,updatedate, schedule_pw schedulePw from schedule where schedule_date = ? order by schedule_time asc";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, y+"-"+strM+"-"+strD);
		System.out.println(stmt + " <-- scheduleListByDate stmt");
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
        <title>scheduleListByDate</title>
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
                <h1 class="text-white fs-3 fw-bolder">스케줄입력</h1>
                <p class="text-white-50 mb-0">자기만 스케줄을 만들어 보세요</p>
            </div>
        </header>
        <!-- Content section-->
                      <form action="insertScheduleAction.jsp" method="post">
							<table class="table">
								<tr>
									<th >날짜</th>
									<td>
										<input type="date" name="scheduleDate" value="<%=y%>-<%=strM%>-<%=strD%>"
										readonly="readonly">
									</td>
								</tr>
								<tr>
									<th>시간</th>
									<td>
										<input type="time" name="scheduleTime">
									</td>
								</tr>
								<tr>
									<th>색상</th>
									<td>
										<input type="color" name="scheduleColor" value="#0000000">
									</td>
								</tr>
								<tr>
									<th>메모</th>
									<td>
										<textarea cols= " 80" rows="3" name="scheduleMemo"></textarea>
									</td>
								</tr>
								<tr>
									<td>비밀번호</td>
									<td>
										<input type="password" name="schedulePw">
									</td>
								</tr >
							</table>
					   			 <button type="submit" class="btn btn-outline-dark">입력</button>
						</form>
        <!-- Image element - set the background image for the header in the line below-->
        <div class="py-5 bg-image-full" style="background-image: url('https://source.unsplash.com/4ulffa6qoKA/1200x800')">
            <!-- Put anything you want here! The spacer below with inline CSS is just for demo purposes!-->
            <div style="height: 20rem"></div>
        </div>
        <!-- Content section-->
      
                    <h1><%=y%>년 <%=m%>월 <%=d%>일 스케줄 목록</h1>
              			  <table class="table">
								<tr>
									<th>넘버(클릭시 상세보기 수정과 삭제 가능)</th>
									<th>schedule_time</th>
									<th>schedule_memo</th>
									<th>createdate</th>
									<th>updatedate</th>
								</tr>
								<%
									for(Schedule s : scheduleList){
								%>
										<tr>
											<td>
						             			<a class="glanlink" href="./scheduleOne.jsp?scheduleNo=<%=s.scheduleNo%>"><%=s.scheduleNo%>
						               			</a>
						          		    </td>
											<td><%=s.scheduleTime%></td>
											<td><%=s.scheduleMemo%></td>
											<td><%=s.createdate%></td>
											<td><%=s.updatedate%></td>
						
										</tr>
								<% 		
									}
								%>
							</table>
                
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
