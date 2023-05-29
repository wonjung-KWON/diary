<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.Connection" %>
<%@ page import = "java.sql.DriverManager" %>
<%@ page import = "java.sql.PreparedStatement" %>
<%	
//요청값 유효성 검사
	if(request.getParameter("noticeNo") == null 
			|| request.getParameter("noticePw") == null
			|| request.getParameter("noticeNo").equals("")
			|| request.getParameter("noticePw").equals("")) {
		response.sendRedirect("./noticeList.jsp");
		return; // 페이지 멈춰!
	}
	
	int noticeNo = Integer.parseInt(request.getParameter("noticeNo"));
	String noticePw = request.getParameter("noticePw");
	
	System.out.println(noticeNo + "<-- param noticeNo");
	System.out.println(noticePw + "<-- param noticePw");
	//DB연동하는 코드
		//드라이버 로딩
		Class.forName("org.mariadb.jdbc.Driver");
		//디버깅체크~
		System.out.println("드라이버 로딩 성공했어");
		//마리아 디비 연결 유지해줍니다.
		Connection conn = DriverManager.getConnection(
				"jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
		System.out.println("접속 됌"+conn);
	// delete from notice where notice_no=?and notice_pw=? 쿼리 코드 sql에다가 넣어야 할 것 ? 에는 사용자가 보내는 것을 	능동적으로 받는것
		String sql = "delete from notice where notice_no=? and notice_pw=?";	
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, noticeNo);
		stmt.setString(2, noticePw);
		System.out.println(stmt + "<-- deleteNoticeAction sql");
	
	int row = stmt.executeUpdate();
	// row 디버깅 확인하기
	System.out.println(row + "<-- deleteNoticeAction row");
	
	if(row == 0) {// 비밀번호가 틀려서 반환값을 못받고 0일 경우
		response.sendRedirect("./deletenoticeForm.jsp?noticeNo="+noticeNo);
	}else {
		response.sendRedirect("./noticeList.jsp");// 틀려으니 페이지 이동시켜버리기
	}
%>