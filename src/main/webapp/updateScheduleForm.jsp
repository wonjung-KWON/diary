<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>
<%
	

	if(request.getParameter("scheduleNo") == null){
		response.sendRedirect("./scheduleList.jsp");
		return;
	}
		int scheduleNo = Integer.parseInt(request.getParameter("scheduleNo")); // scheduleOne 에서 받은 scheduleNo 인트 변수에 저장
		System.out.print(scheduleNo + "<-- updateScheduleForm(scheduleNo)"); // scheduleNo 변수에 잘 들어갔는지 디버깅 확인
		Class.forName("org.mariadb.jdbc.Driver");
		System.out.println(" updateScheduleForm 드라이버 로딩 성공함"); // 드라이버 로딩 확인
		Connection conn = DriverManager.getConnection(
				"jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
		System.out.println(" updateScheduleForm 접속 됌"+conn); // 연결 잘됐는지 확인
		/*
			select schedule_no, schedule_date, schedule_time, schedule_memo, schedule_color, schedule_pw , createdate, updatedate 
			from schedule
			where schedule_no = ?
		*/
		String sql = "select schedule_no scheduleNo, schedule_date scheduleDate, schedule_time scheduleTime, schedule_memo scheduleMemo, schedule_color scheduleColor, schedule_pw schedulePw, createdate, updatedate from schedule where schedule_no = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, scheduleNo);
		System.out.println(stmt + " <-- updateScheduleForm stmt");
		ResultSet rs = stmt.executeQuery();
		System.out.println(rs+"<-- updateScheduleForm rs ");
		ArrayList<Schedule> scheduleList = new ArrayList<Schedule>();
		while(rs.next()){
			Schedule s = new Schedule(); //rs 의 개수만큼 만들어줌
			s.scheduleNo = rs.getInt("scheduleNo");
			s.scheduleDate = rs.getString("scheduleDate");
			s.scheduleTime = rs.getString("scheduleTime");// 쿼리에서 날짜만 가져옴으로써 날짜값만 들어온다. day(schedule_date) scheduleDate
			s.scheduleMemo = rs.getString("scheduleMemo"); //subString을 활용해서 전체가 아닌 설정값만 들어온다.
			s.scheduleColor = rs.getString("scheduleColor");
			s.schedulePw = rs.getString("schedulePw");
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
        <title>updateScheduleForm</title>
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
                <h1 class="text-white fs-3 fw-bolder">수정 입력</h1>
                <p class="text-white-50 mb-0">
                <% // 에러 메신저가 들어갔을때만 보여주기 위해 if문활용
					if(request.getParameter("msg") != null){
				%>
					<%=request.getParameter("msg")%>
				<%
					}
				%>
				</p>
            </div>
        </header>
        <!-- Content section-->
       
                     <form action="./updateScheduleAction.jsp" method="post">
							<table class="table">
									<%
										for(Schedule s : scheduleList){
									%>
									<tr>
										<th >스케줄 번호</th>
										<td>
											<input type="text" name="scheduleNo" value="<%=s.scheduleNo%>"
											readonly="readonly">
										</td>
									</tr>
									<tr>
										<th >날짜</th>
										<td>
											<input type="date" name="scheduleDate" value="<%=s.scheduleDate%>"
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
											<textarea cols= "80" rows="3" name="scheduleMemo" value="<%=s.scheduleMemo%>">
											</textarea>
										</td>
									</tr>
									<tr>
										<td>비밀번호</td>
										<td>
											<input type="password" name="schedulePw">
										</td>
									</tr >
									<tr>
										<td>만든날짜</td>
										<td>
											
												<%=s.createdate %>
											
										</td>
									</tr>
									<tr>
										<td>수정날짜</td>
										<td>
											
												<%=s.updatedate%>
											
										</td>
									</tr>
									<%
										}
									%>
								</table>
							
							<button type="submit" class="btn btn-outline-dark">수정</button>
						
						</form>
				
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
