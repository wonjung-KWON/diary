<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%	
	
	request.setCharacterEncoding("utf-8"); //한글 인코딩
	//유효성 검사 필수 getParameter값
		if(request.getParameter("scheduleDate") == null
				|| request.getParameter("scheduleTime") == null
				|| request.getParameter("scheduleColor") == null
				|| request.getParameter("schedulePw") == null
						|| request.getParameter("scheduleMemo") == null
				|| request.getParameter("scheduleDate").equals("")
				|| request.getParameter("scheduleTime").equals("")
				|| request.getParameter("scheduleColor").equals("")
				|| request.getParameter("schedulePw").equals("")
				|| request.getParameter("scheduleMemo").equals("")){
			
			response.sendRedirect("./scheduleListByDate.jsp");
			return;
		}
	//scheduleListByDate 에서 불러온 값들 String변수에 저장
	String scheduleDate = request.getParameter("scheduleDate"); 
	String scheduleTime = request.getParameter("scheduleTime");
	String scheduleColor = request.getParameter("scheduleColor");
	String scheduleMemo = request.getParameter("scheduleMemo");
	String schedulePw = request.getParameter("schedulePw");
	// 가져온 값이 잘들어왔는지 디버깅 확인
	System.out.println(scheduleDate + "<-- insertScheduleAction param scheduleDate");
	System.out.println(scheduleTime + "<-- insertScheduleAction param scheduleTime");
	System.out.println(scheduleColor + "<-- insertScheduleAction param scheduleColor");
	System.out.println(scheduleMemo + "<-- insertScheduleAction param scheduleMemo");
	System.out.println(schedulePw + "<-- insertScheduleAction param schedulePw");
	
	//DB연동하는 코드
			//드라이버 로딩
			Class.forName("org.mariadb.jdbc.Driver");
			//디버깅체크~
			System.out.println("드라이버 로딩 성공했어");
			//마리아 디비 연결 유지해줍니다.
			Connection conn = DriverManager.getConnection(
					"jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
			System.out.println("접속 확인"+conn);
			conn.setAutoCommit(true);
			String sql = "insert into schedule(schedule_date, schedule_time, schedule_color, schedule_memo, schedule_pw, createdate, updatedate) value(?,?,?,?,?,now(),now())";
			PreparedStatement stmt = conn.prepareStatement(sql);
			// ? 5개이므로 1부터 5까지이다. ?문 대체 넣어주기!
			stmt.setString(1, scheduleDate);
			stmt.setString(2, scheduleTime);
			stmt.setString(3, scheduleColor);
			stmt.setString(4, scheduleMemo);
			stmt.setString(5, schedulePw);
			System.out.println(stmt + "<-- insertScheduleAction stmt 입력값확인");
			
			int row = stmt.executeUpdate(); //쿼리? 디버깅 할때 활용하는 코드 
			if(row == 1){
				System.out.println(row + "<-- insertScheduleAction row 디버깅 코드");//입력결과확인
			}else{
				System.out.println(row + "<-- insertScheduleAction row 디버깅 코드");//입력결과확인
			}
	
	// scheduleDate 저장된 값들 자리에 맞게 짤라서 저장하기
	String y = scheduleDate.substring(0,4);
	int m = Integer.parseInt(scheduleDate.substring(5,7))-1; // -1은 scheduleListByDate에서 월을 플러스 1해서 가져왔기 때문에 다시 마이너스 1을 해야된다 플러스 1한 이유는 그 페이지에
	String d = scheduleDate.substring(8);
	// 짤라서 변수에 잘 들어갔는지 디버깅해서 확인하기
	System.out.println(y + "<-- insertScheduleAction y");
	System.out.println(m + "<-- insertScheduleAction m");
	System.out.println(d + "<-- insertScheduleAction d");
	


		
		
	//scheduleListByDate에 값들을 다시 보내기
	response.sendRedirect("./scheduleListByDate.jsp?y="+y+"&m="+m+"&d="+d);

%>
