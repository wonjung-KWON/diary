<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%	
//요청값 유효성 검사
	if(request.getParameter("scheduleNo") == null 
			|| request.getParameter("schedulePw") == null
			|| request.getParameter("scheduleNo").equals("")
			|| request.getParameter("schedulePw").equals("")) {
		response.sendRedirect("./scheduleList.jsp");
		return; // 페이지 멈춰!
	}
	
	int scheduleNo = Integer.parseInt(request.getParameter("scheduleNo")); // scheduleNo 파라메라 값을 인트 변수에 저장하기
	String schedulePw = request.getParameter("schedulePw"); //schedulePw 파라메라 값을 인트 변수에 저장
	
	System.out.println(scheduleNo + "<-- deleteScheduleAction param scheduleNo");  // scheduleNo 잘들어갔는지 확인
	System.out.println(schedulePw + "<-- deleteScheduleAction param schedulePw");	// schedulePw 잘들어갔는지 확인
	//DB연동하는 코드
		//드라이버 로딩
		Class.forName("org.mariadb.jdbc.Driver");
		//디버깅체크~
		System.out.println(" deleteScheduleAction 드라이버 로딩 성공함"); // 드라이버 로딩 확인
		//마리아 디비 연결 유지해줍니다.
		Connection conn = DriverManager.getConnection(
				"jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
		System.out.println("deleteScheduleAction 접속 됌"+conn); // 연결 잘됐는지 확인
	// delete from schedule where schedule_no=?and schedule_pw=? 쿼리 코드 sql에다가 넣어야 할 것 ? 에는 사용자가 보내는 것을 능동적으로 받는것
		String sql = "delete from schedule where schedule_no=? and schedule_pw=?";	
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, scheduleNo);
		stmt.setString(2, schedulePw);
		System.out.println(stmt + "<-- deleteScheduleAction stmt 체크"); // stmt 체크
	
	int row = stmt.executeUpdate(); // int row에 값없데이트?
	// row 디버깅 확인하기
	System.out.println(row + "<-- deleteScheduleAction row 체크");
	
	if(row == 0) {// 비밀번호가 틀려서 반환값을 못받고 0일 경우
		response.sendRedirect("./scheduleOne.jsp?storeNo="+scheduleNo);
	}else {
		response.sendRedirect("./scheduleList.jsp");// 비밀번호 맞았을때 돌아갈 페이지
	}
%>