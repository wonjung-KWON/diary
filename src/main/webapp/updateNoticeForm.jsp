<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>
<%
	//유효성 코드 추가 -> 분기 -> return - 페이지 종료하기 else 문으로 가지 않기위해 return으로 끝내버리기 강사님이 좋아하는 블럭이 작은 장점이 있다.
 	if(request.getParameter("noticeNo") == null) {
		response.sendRedirect("./noticeList.jsp");
		return; // 1) 코드진행종료 2) 반환값을 남길때
	}
	
	int noticeNo = Integer.parseInt(request.getParameter("noticeNo"));
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection(
			"jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
	/*
		select notice_no, notice_title, notice_content, notice_writer, createdate, updatedate 
		from notice 
		where notice_no = ?
	*/
	String sql = "select notice_no noticeNo, notice_title noticeTitle, notice_content noticeContent, notice_writer noticeWriter, createdate, updatedate from notice where notice_no = ?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1, noticeNo);
	System.out.println(stmt + " <-- stmt");
	ResultSet rs = stmt.executeQuery();
	System.out.println(rs+"<--rs");
	ArrayList<Notice> noticeList = new ArrayList<Notice>();
	while(rs.next()){ // 와일문을 활용하여 rs 에 있는 값들을 ArrayList에 저장
		Notice n = new Notice();
		n.noticeNo = rs.getInt("noticeNo");
		n.noticeTitle = rs.getString("noticeTitle");
		n.noticeContent = rs.getString("noticeContent");
		n.noticeWriter = rs.getString("noticeWriter");
		n.createdate = rs.getString("createdate");
		n.updatedate = rs.getString("updatedate");
		noticeList.add(n);		
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
        <title>updateNoticeForm</title>
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
                <img class="img-fluid rounded-circle mb-4" src="./imges/notice.jpg" alt="..." style="width: 150px; height: 150px;"/>
                <h1 class="text-white fs-3 fw-bolder">수정 입력</h1>
                <p class="text-white-50 mb-0">
                <%
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
        <section class="py-5">
            <div class="container my-5">
                <div class="row justify-content-center">
                    <div class="col-lg-6">
                      <form action="updateNoticeAction.jsp" method="post">
							<table class="table">
									<%
										for(Notice n : noticeList){
									%>
								
									<tr >
										<td>notice_no</td>
										<td>
											<input type="number" name="noticeNo" value="<%=n.noticeNo%>" readonly="readonly">
										</td>
									</tr>
									<tr>
										<td>notice_pw</td>
										<td>
											<input type="password" name="noticePw" >
										</td>
									</tr>
									<tr>
										<td>notice_title</td>
										<td>
											<input type="text" name="noticeTitle" value="<%=n.noticeTitle%>" >
										</td>
									</tr>
									<tr>
										<td>notice_content</td>
										<td>
											<textarea rows="5" cols="80"name="noticeContent">
												<%=n.noticeContent%>
											</textarea>
										</td>
									</tr>
									<tr>
										<td>notice_writer</td>
										<td>
										
												<%=n.noticeWriter%>
											
										</td>
									</tr>
									<tr>
										<td>createdate</td>
										<td>
											
												<%=n.createdate %>
											
										</td>
									</tr>
									<tr>
										<td>updatedate</td>
										<td>
											
												<%=n.updatedate%>
											
										</td>
									</tr>
									<%
										}
									%>
									
							</table>
								<button type="submit" class="btn btn-outline-dark" >수정</button>
						</form>
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
