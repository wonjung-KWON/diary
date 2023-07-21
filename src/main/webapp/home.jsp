<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>
<!-- 날짜순 최근 공지 5개 & -->
	<%
		// select notice_no, notice_title, createdate from notice 
		// order by createdate desc
		// limit 0, 5
		// 1)
		Class.forName("org.mariadb.jdbc.Driver");
		// 2)
		Connection conn = DriverManager.getConnection(
				"jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
		//최근 공지5개
		String sql1 = "select notice_no noticeNo, notice_title noticeTitle, createdate from notice order by createdate desc limit 0, 5";
		PreparedStatement stmt1 = conn.prepareStatement(sql1);
		System.out.println(stmt1 + " <-- stmt2");
		ResultSet rs1 = stmt1.executeQuery();
		ArrayList<Notice> noticeList = new ArrayList<Notice>();
		while(rs1.next()){ // 와일문을 활용하여 rs 에 있는 값들을 ArrayList에 저장
			Notice n = new Notice();
			n.noticeNo = rs1.getInt("noticeNo");
			n.noticeTitle = rs1.getString("noticeTitle");
			n.createdate = rs1.getString("createdate");
			noticeList.add(n);
		}
		
		
		//오늘 일정
		/*오늘일정 쿼리
		SELECT schedule_no schedule_date, schedule_time, substr(schedule_memo,1,10) AS=(알리어스 이름이 너무 길어서 memo로 바꿔는 쿼리 AS는 생략 가능하다) memo
		FROM SCHEDULE
		WHERE schedule_date = CURDATE()
		ORDER BY schedule_time ASC;
		*/
		  String sql2 = "select schedule_no scheduleNo, schedule_date scheduleDate, schedule_time scheduleTime, substr(schedule_memo,1,10) scheduleMemo from schedule where schedule_date = curdate() order by schedule_time asc";
	      PreparedStatement stmt2 = conn.prepareStatement(sql2);
	      System.out.println(stmt2 + " <-- stmt2");
	      ResultSet rs2 = stmt2.executeQuery();  
	      ArrayList<Schedule> scheduleList = new ArrayList<Schedule>();
	  	while(rs2.next()){
	  		Schedule s = new Schedule(); //rs 의 개수만큼 만들어줌
	  		s.scheduleNo = rs2.getInt("scheduleNo");
	  		s.scheduleDate = rs2.getString("scheduleDate"); // 쿼리에서 날짜만 가져옴으로써 날짜값만 들어온다. day(schedule_date) scheduleDate
	  		s.scheduleTime = rs2.getString("scheduleTime"); //subString을 활용해서 전체가 아닌 설정값만 들어온다.
	  		s.scheduleMemo = rs2.getString("scheduleMemo");
	  		scheduleList.add(s);
	  	}
	%>
<!DOCTYPE html>
<html lang="en">
    <head>
    <style type="text/css">
		.glanlink {color: #000000;text-decoration: none;}
	</style>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
        <meta name="description" content="" />
        <meta name="author" content="" />
        <title>home.jsp</title>
        <!-- Favicon-->
        <link rel="icon" type="image/x-icon" href="./Resources/assets/favicon.ico" />
        <!-- Core theme CSS (includes Bootstrap)-->
        <link href="./Resources/css/styles.css" rel="stylesheet" />
    </head>
    <body>
        <!-- Responsive navbar-->
        <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
            <div class="container">
                <a class="navbar-brand" href="./insertNoticeForm.jsp">공지입력</a>
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
                <img class="img-fluid rounded-circle mb-4" src="./imges/notice.jpg" alt="..." style="width: 150px; height: 150px;"/>
                <h1 class="text-white fs-3 fw-bolder">공지사항</h1>
                <p class="text-white-50 mb-0">최근 공지사항들</p>
            </div>
        </header>
        <!-- Content section-->
        <section class="py-5">
            <div class="container my-5">
                <div class="row justify-content-center">
                    <div class="col-lg-6">
                       <table  class="table">
							<tr>
								<th>notice_title</th>
								<th>createdate</th>
							</tr>
							<%
								for(Notice n : noticeList){
							%>
								<tr>
									<td>
										<a class="glanlink" href="./noticeOne.jsp?noticeNo=<%= n.noticeNo%>">
											<%=n.noticeTitle%>
										</a>
									</td>
									<td><%=n.createdate.substring(0, 10)%></td>
								</tr>
							<%		
								}
							%>
						</table>
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
        <section class="py-5">
            <div class="container my-5">
                <div class="row justify-content-center">
                    <div class="col-lg-6">
                    <h1>오늘의 일정</h1>
              			  <table class="table table-hover">
							<tr>
								<th>schedule_date</th>
								<th>schedule_time</th>
								<th>schedule_memo</th>
							</tr>
							<%
							for(Schedule s : scheduleList){
							%>
							 <tr>
					            <td>
					               <%=s.scheduleDate%>
					            </td>
					            <td><%=s.scheduleTime%></td>
					            <td>
					               <a class="glanlink" href="./scheduleOne.jsp?scheduleNo=<%=s.scheduleNo%>">
					                  <%=s.scheduleMemo%>
					               </a>
					            </td>
					         </tr>
							<%
								}
							%>
						</table>
                    </div>
                </div>
            </div>
        </section>
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
