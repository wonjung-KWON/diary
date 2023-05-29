<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%
	request.setCharacterEncoding("utf-8");//post인코딩 한글 될수있는 인코딩될수있게 처리
	//updateScheduleForm에서 보내는 값을 디버깅하여서 체크하기
		System.out.println(request.getParameter("scheduleNo")+"<-- updateScheduleForm에서 scheduleNo 보낸 값 확인");
		System.out.println(request.getParameter("scheduleDate")+"<-- updateScheduleForm에서 scheduleDate 보낸 값 확인");
		System.out.println(request.getParameter("scheduleTime")+"<-- updateScheduleForm에서 scheduleTime 보낸 값 확인");
		System.out.println(request.getParameter("scheduleColor")+"<-- updateScheduleForm에서 scheduleColor 보낸 값 확인");
		System.out.println(request.getParameter("scheduleMemo")+"<-- updateScheduleForm에서 scheduleMemo 보낸 값 확인");
		System.out.println(request.getParameter("schedulePw")+"<-- updateScheduleForm에서 schedulePw 보낸 값 확인");
	if(request.getParameter("scheduleNo")== null 
		         || request.getParameter("scheduleNo").equals("")) {
			   response.sendRedirect("./scheduleList.jsp"); //리다이렉션이란 엑션을 요청한 브라우저에게 다른곳을 요청하라고 말하는 것이다
			   return;
			}
			//return - 페이지 종료하고 else 문으로 가지 않거 return으로 끝내기 블럭이 작다는 장점이 있다
	String msg = null;
	if(request.getParameter("scheduleDate")==null 
	         || request.getParameter("scheduleDate").equals("")) {
	         msg = "scheduleDate is required";
	   } else if(request.getParameter("scheduleTime")==null 
	         || request.getParameter("scheduleTime").equals("")) {
	         msg = "scheduleTime is required";
	   } else if(request.getParameter("scheduleColor")==null 
	         || request.getParameter("scheduleColor").equals("")) {
	         msg = "scheduleColor is required";
	   } else if(request.getParameter("scheduleMemo")==null 
		         || request.getParameter("scheduleMemo").equals("")) {
		         msg = "scheduleMemo is required";
	   } else if(request.getParameter("schedulePw")==null 
		         || request.getParameter("schedulePw").equals("")) {
		         msg = "schedulePw is required"; 
	   }
		
	   if(msg != null) { // 위 ifelse문에 하나라도 해당된다
	      response.sendRedirect("./updateScheduleForm.jsp?scheduleNo="
	                        +request.getParameter("scheduleNo")
	                        +"&msg="+msg);
		return; 
	}	
	   // 요청값들을 매번 request.getParameter 를 쓰기 힘드니 변수에 형변환까지 다 하고 담아둬서 편하게 쓰자@!!!!
	int scheduleNo = Integer.parseInt(request.getParameter("scheduleNo")); // scheduleNo 파라메라 값을 인트 변수에 저장하기
	String scheduleDate = request.getParameter("scheduleDate"); //scheduleDate 파라메라 값을 변수에 저장
	String scheduleTime = request.getParameter("scheduleTime"); //scheduleTime 파라메라 값을  변수에 저장
	String scheduleColor = request.getParameter("scheduleColor"); //scheduleColor 파라메라 값을 인변수에 저장
	String scheduleMemo = request.getParameter("scheduleMemo"); //scheduleMemo 파라메라 값을 인트 변수에 저장
	String schedulePw = request.getParameter("schedulePw");
	
	System.out.println(scheduleNo + "<-- updateScheduleAction param scheduleNo");  // scheduleNo 잘들어갔는지 확인
	System.out.println(scheduleDate + "<-- updateScheduleAction param scheduleDate");	// scheduleDate 잘들어갔는지 확인
	System.out.println(scheduleTime + "<-- updateScheduleAction param scheduleTime");// scheduleTime 잘들어갔는지 확인
	System.out.println(scheduleColor + "<-- updateScheduleAction param scheduleColor");// scheduleColor 잘들어갔는지 확인
	System.out.println(scheduleMemo + "<-- updateScheduleAction param scheduleMemo");// scheduleMemo 잘들어갔는지 확인
	System.out.println(schedulePw + "<-- updateScheduleAction param schedulePw");// schedulePw 잘들어갔는지 확인
	
	//DB연동하는 코드
			//드라이버 로딩
			Class.forName("org.mariadb.jdbc.Driver");
			//디버깅체크~
			System.out.println("드라이버 로딩 성공함"); // 드라이버 로딩 확인
			//마리아 디비 연결 유지해줍니다.
			Connection conn = DriverManager.getConnection(
					"jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
			System.out.println("접속 됌"+conn); // 연결 잘됐는지 확인
		// "update schedule set schedule_date=?, schedule_time=?, schedule_color=?, schedule_memo=?, updatedate=now() where schedule_no=? and schedule_pw=?"
		 //쿼리 코드 sql에다가 넣어야 할 것 ? 에는 사용자가 보내는 것을 능동적으로 받는것
			String sql = "update schedule set schedule_date=?, schedule_time=?, schedule_color=?, schedule_memo=?, updatedate=now() where schedule_no=? and schedule_pw=?";
			PreparedStatement stmt = conn.prepareStatement(sql);
			stmt.setString(1, scheduleDate);
			stmt.setString(2, scheduleTime);
			stmt.setString(3, scheduleColor);
			stmt.setString(4, scheduleMemo);
			stmt.setInt(5, scheduleNo);
			stmt.setString(6, schedulePw);
			
			System.out.println(stmt + "<-- updateScheduleAction stmt 체크"); // stmt 체크
			
			int row = stmt.executeUpdate(); // int row에 값없데이트?
			// row 디버깅 확인하기
			System.out.println(row + "<-- updateScheduleAction row 체크");
			
			if(row == 0) {// 비밀번호가 틀려서 반환값을 못받고 0일 경우
			      response.sendRedirect("./updateScheduleForm.jsp?scheduleNo="
			      		+scheduleNo
			            +"&msg=incorrect schedulePw");
						System.out.println(row+"비번틀림");
			   } else if(row == 1) {
			      response.sendRedirect("./scheduleOne.jsp?scheduleNo="+scheduleNo);
			   } else {
			      
			      System.out.println("error row값 : "+row);// 
			   }
	
%>	