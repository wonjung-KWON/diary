<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.Connection" %>
<%@ page import = "java.sql.DriverManager" %>
<%@ page import = "java.sql.PreparedStatement" %>
<%	
	request.setCharacterEncoding("utf-8");//post인코딩 처리
	// validation(요청 파라미터값 유효성 검사)
	
	//유효성 검사 필수 getParameter값
	if(request.getParameter("noticeTitle") == null
			|| request.getParameter("noticeContent") == null
			|| request.getParameter("noticeWriter") == null
			|| request.getParameter("noticePw") == null
			|| request.getParameter("noticeTitle").equals("")
			|| request.getParameter("noticeContent").equals("")
			|| request.getParameter("noticeWriter").equals("")
			|| request.getParameter("noticePw").equals("")){
		
		response.sendRedirect("./insertNoticeForm.jsp");
		return;
	}
	String noticeTitle = request.getParameter("noticeTitle");
	String noticeContent = request.getParameter("noticeContent");
	String noticeWriter = request.getParameter("noticeWriter");
	String noticePw = request.getParameter("noticePw");
	


	// 값들을 DB 테이블에 입력 = 쿼리
	/* 
		insert into notice(
				notice_title, notice_contemt, notice_writer, notice_pw. createdate, updatedate 
		)values(?,?,?,?,now(),now())
	*/
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection(
			"jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
	
	String sql= "insert into notice(notice_title, notice_content, notice_writer, notice_pw, createdate, updatedate) values(?,?,?,?,now(),now())";
	PreparedStatement stmt = conn.prepareStatement(sql);
	// ? 4개(1~4)
	stmt.setString(1, noticeTitle);
	stmt.setString(2, noticeContent);
	stmt.setString(3, noticeWriter);
	stmt.setString(4, noticePw);
	int row = stmt.executeUpdate(); // 디버깅 할때 필요함, 실행해주세요, 디버깅 1(ex:2)이면 1행(ex:2행) 입력 성공, 0이면 입력된 행이 없다
	// row 값을 이용한 디버깅
	
	//conn.setAutoCommit(true); //이 있으면 //conn.commit(): 생략 가능함
	//conn.commit(); //최종 반영을 하세요
	
	// redirection
	response.sendRedirect("./noticeList.jsp");
%>