<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>
<%
	//요청값이 유효성이 있는 지 없는 지 확인하는 문장?
	if(request.getParameter("scheduleNo") == null) {
		response.sendRedirect("./scheduleList.jsp");
		return; // 페이지 멈춰!//return - 페이지 종료하고 else 문으로 가지 않거 return으로 끝내기 블럭이 작다는 장점이 있다
	}
		int scheduleNo = Integer.parseInt(request.getParameter("scheduleNo"));
		System.out.println(scheduleNo + "<--deleteScheduleForm 파라메라 scheduleNo 값 확인");
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
        <title>deleteScheduleForm</title>
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
                <h1 class="text-white fs-3 fw-bolder">스케줄 삭제</h1>
                <p class="text-white-50 mb-0">신중하게 삭제해주시기 바랍니다.</p>
            </div>
        </header>
        <!-- Content section-->
        <section class="py-5">
            <div class="container my-5">
                <div class="row justify-content-center">
                    <div class="col-lg-6">
                      <form action="./deleteScheduleAction.jsp" method="post">
							<table class="table">
								<tr>
									<td>스케줄 번호</td>
									<td>
										<input type="text" name="scheduleNo" value="<%=scheduleNo%>" readonly="readonly">
									</td>
								</tr>
								<tr>
									<td>비밀번호</td>
									<td>
										<input type="password" name="schedulePw"> 
									</td>
								</tr>
							</table>
							<button type="submit" class="btn btn-outline-dark">삭제</button>
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
