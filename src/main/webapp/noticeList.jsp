<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>
<%
	// 요청 분석(currentPage, ....)
	// 현재페이지
	int currentPage = 1;
	if(request.getParameter("currentPage") != null) {
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	System.out.println(currentPage + " <--currentPage");
	
	// 페이지당 출력할 행의 수
	int rowPerPage = 10;
	
	// 시작 행번호
	int startRow = (currentPage-1)*rowPerPage;
	/*
		currentPage		startRow(rowPerPage 10일때)	
		1				0	<-- (currentPage-1)*rowPerPage
		2				10
		3				20
		4				30
	*/


	// DB연결 설정
	// select notice_no, notice_title, createdate from notice 
	// order by createdate desc
	// limit ?, ?
			
			
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection(
			"jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
	PreparedStatement stmt = conn.prepareStatement("select notice_no noticeNo, notice_title noticeTitle, createdate from notice order by createdate desc limit ?, ?"); // 
	stmt.setInt(1, startRow);
	stmt.setInt(2, rowPerPage);
	System.out.println(stmt + " <-- stmt");
	// 출력할 공지 데이터
	ResultSet rs = stmt.executeQuery();	// Set중복된 데이터가 절대 들어오지 않는다는 장점이있다 Set은 쓰기 매우 불편해서 List로 바꿔서 사용하는게 좋다
	//자료구조 ResultSet 타입을 일반적인 자료구조타입(자바 배열 or 기본API 자료구조타입 List, Set(순서가 없어서 쓰기힘듬), Map) 배열은 정적배열이라 데이터 수를 알아야되므로 매우쓰기 힘듬
	// ResultSet -> ArrayList<Notice>로 바꿔주면 모든자바 프로그램에서 다른사람이 쉽게 사용할수있게된다.
	ArrayList<Notice> noticeList = new ArrayList<Notice>();
	while(rs.next()){ // 와일문을 활용하여 rs 에 있는 값들을 ArrayList에 저장
		Notice n = new Notice();
		n.noticeNo = rs.getInt("noticeNo");
		n.noticeTitle = rs.getString("noticeTitle");
		n.createdate = rs.getString("createdate");
		noticeList.add(n);
	}
	
	// 마지막 페이지
	// select count(*) from notice
	PreparedStatement stmt2 = conn.prepareStatement("select count(*) from notice");
	ResultSet rs2 = stmt2.executeQuery();
	int totalRow = 0; // SELECT COUNT(*) FROM notice;
	if(rs2.next()) {
		totalRow = rs2.getInt("count(*)");
	}
	int lastPage = totalRow / rowPerPage;
	if(totalRow % rowPerPage != 0) {
		lastPage = lastPage + 1;
	}
	//오늘 일정
			/*오늘일정 쿼리
			SELECT schedule_no schedule_date, schedule_time, substr(schedule_memo,1,10) AS=(알리어스 이름이 너무 길어서 memo로 바꿔는 쿼리 AS는 생략 가능하다) memo
			FROM SCHEDULE
			WHERE schedule_date = CURDATE()
			ORDER BY schedule_time ASC;
			*/
			  String sql3 = "select schedule_no scheduleNo, schedule_date scheduleDate, schedule_time scheduleTime, substr(schedule_memo,1,10) scheduleMemo from schedule where schedule_date = curdate() order by schedule_time asc";
		      PreparedStatement stmt3 = conn.prepareStatement(sql3);
		      System.out.println(stmt3 + " <-- stmt3");
		      ResultSet rs3 = stmt3.executeQuery();  
		      ArrayList<Schedule> scheduleList = new ArrayList<Schedule>();
		  	while(rs3.next()){
		  		Schedule s = new Schedule(); //rs 의 개수만큼 만들어줌
		  		s.scheduleNo = rs3.getInt("scheduleNo");
		  		s.scheduleDate = rs3.getString("scheduleDate"); // 쿼리에서 날짜만 가져옴으로써 날짜값만 들어온다. day(schedule_date) scheduleDate
		  		s.scheduleTime = rs3.getString("scheduleTime"); //subString을 활용해서 전체가 아닌 설정값만 들어온다.
		  		s.scheduleMemo = rs3.getString("scheduleMemo");
		  		scheduleList.add(s);
		  	}
%>
<!DOCTYPE html>
<html lang="en">
    <head>
    <style type="text/css">
		.glanlink {color: #000000;}
	</style>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
        <meta name="description" content="" />
        <meta name="author" content="" />
        <title>noticeList.jsp</title>
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
                <img class="img-fluid rounded-circle mb-4" src="./imges/notice.jpg	" alt="..." style="width: 150px; height: 150px;"/>
                <h1 class="text-white fs-3 fw-bolder">공지사항 리스트</h1>
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
										<a class="glanlink" href="./noticeOne.jsp?noticeNo=<%=n.noticeNo%>">
											<%=n.noticeTitle%>
										</a>
									</td>
									<td><%=n.createdate.substring(0, 10)%></td>
								</tr>
							<%		
								}
							%>
						</table>
						
						<%
							if(currentPage > 1) {
						%>
								<a class="glanlink" href="./noticeList.jsp?currentPage=<%=currentPage-1%>">이전</a>
						<%		
							}
						%>
								<%=currentPage%>
						<%	
							if(currentPage < lastPage) {	
						%>
								<a class="glanlink" href="./noticeList.jsp?currentPage=<%=currentPage+1%>">다음</a>
						<%
							}
						%>
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
              			  <table   class="table">
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
