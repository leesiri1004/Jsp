package kr.co.jboard1.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import kr.co.jboard1.bean.ArticleBean;
import kr.co.jboard1.bean.FileBean;
import kr.co.jboard1.db.DBConfig;

public class ArticleDao {

	private static ArticleDao instance = new ArticleDao();
	private ArticleDao() {}
	public static ArticleDao getInstance() {
		return instance;
	}

	private Connection conn			= null;
	private PreparedStatement psmt 	= null;
	private Statement stmt 			= null;
	private ResultSet rs 			= null;
	
	
	// 페이지번호 그룹 구하기
	public int[] getPageGroup(int currentPg, int lastPgNum) {
		int groupCurrent = (int)Math.ceil(currentPg / 10.0);
		int groupStart = (groupCurrent - 1) * 10 +1;
		int groupEnd = groupCurrent * 10;

		if(groupEnd > lastPgNum){
			groupEnd = lastPgNum;
		}
		
		int[] groups = {groupStart, groupEnd};
		
		return groups;
	}
	
	// 현재 페이지 글 시작번호 구하기
	public int getCurrentStartNum(int total, int limitStart) {
		return total - limitStart;
	}
	
	// 현재 페이지 번호 구하기
	public int getCurrentPg(String pg) {
		int currentPg = 1;
		if(pg != null){
			currentPg = Integer.parseInt(pg);
		}
		return currentPg;
	}
	
	// 게시물 LIMIT 시작번호 구하기
	public int getLimitStart(int currentPg) {
		int limitStart = (currentPg - 1) * 10;
		return limitStart;
	}
	
	// 전체 페이지 번호 구하기
	public int getLastPgNum(int total) {
		int lastPgNum = 0; //  page는 예약어 그래서 다른 이름으로 pg
		
		if(total % 10 == 0){
			lastPgNum = total / 10;
		}else{
			lastPgNum = total / 10 + 1;
		}
	
		return lastPgNum;
	}
	
	// 글 순서번호 구하기
	public int selectCountArticle() throws Exception {
		// 1, 2단계
		conn = DBConfig.getInstance().getConnection();
		
		// 3단계
		stmt = conn.createStatement();
		
		// 4단계
		String sql = "SELECT COUNT(*) FROM `JBOARD_ARTICLE`"; // SELECT COUNT(*) = 띄우지않고 COUNT 옆에 바로 (*)붙여야함
		rs = stmt.executeQuery(sql);
		
		// 5단계
		int total = 0;
		if(rs.next()){
			total = rs.getInt(1);
		}
		
		// 6단계
		close();
		
		return total;
	}

	// 첨부파일
	public void insertFile(FileBean fb) throws Exception {
		// 1단계, 2단계, 3단계
		conn = DBConfig.getInstance().getConnection();
		stmt = conn.createStatement();
		
		// 4단계
		String sql  = "INSERT INTO `JBOARD_FILE` SET ";
			   sql += "`parent`="+fb.getParent()+",";
	 	       sql += "`oldName`='"+fb.getOldName()+"',";
		       sql += "`newName`='"+fb.getNewName()+"',";
		       sql += "`rdate`=NOW();";
		stmt.executeUpdate(sql);       

		// 5단계
		// 6단계
		close();
	}
	
	// 게시물 insert 하기
	public int insertArticle(ArticleBean ab) throws Exception {

		conn = DBConfig.getInstance().getConnection();

		// 3단계 - SQL 실행객체 생성
		stmt = conn.createStatement();

		// 4단계
		String sql  = "INSERT INTO `JBOARD_ARTICLE` SET "; // 오타주의***** "INSERT"
		       sql += "`title`='" + ab.getTitle() + "',";
		       sql += "`content`='" + ab.getContent() + "',";
		       sql += "`file`=" + ab.getFile() + ",";
		       sql += "`uid`='" + ab.getUid() + "',";
		       sql += "`regip`='" + ab.getRegip() + "',";
		       sql += "`rdate`=NOW();";
		stmt.executeUpdate(sql);

		// 5단계

		// 6단계
		close();
		
		// 부여된 글번호
		return selectMaxSeq();
	}

	// 첨부파일 선택
	public int selectMaxSeq() throws Exception {
		conn = DBConfig.getInstance().getConnection();
		stmt = conn.createStatement();
		String sql = "SELECT MAX(`seq`) FROM `JBOARD_ARTICLE`;";
		
		rs = stmt.executeQuery(sql);
		
		int parent = 0;
		if (rs.next()) {
			parent = rs.getInt(1);
		}
		
		close();
		
		return parent;
	}
	
	// 조회글 가져오기
	// 수정글 가져오기
	public ArticleBean selectArticle(String seq) throws Exception {
		conn = DBConfig.getInstance().getConnection();

		// 3단계 - SQL 실행객체 생성
		stmt = conn.createStatement();

		// 4단계
		String sql  = "SELECT a.*, b.oldName, b.download FROM `JBOARD_ARTICLE` AS a ";
			   sql += "LEFT JOIN `JBOARD_FILE` AS b ";
		       sql += "ON a.seq = b.parent ";
		       sql += "WHERE a.seq="+seq; // `a.seq`는 틀린표현. 

		rs = stmt.executeQuery(sql);

		// 5단계
		ArticleBean ab = new ArticleBean();

		if (rs.next()) {
			ab.setSeq(rs.getInt(1));
			ab.setParent(rs.getInt(2));
			ab.setComment(rs.getInt(3));
			ab.setCate(rs.getString(4));
			ab.setTitle(rs.getString(5));
			ab.setContent(rs.getString(6));
			ab.setFile(rs.getInt(7));
			ab.setHit(rs.getInt(8));
			ab.setUid(rs.getString(9));
			ab.setRegip(rs.getString(10));
			ab.setRdate(rs.getString(11));
			ab.setOldName(rs.getString(12));
			ab.setDownload(rs.getInt(13));
		}

		// 6단계
		close();

		return ab;
	}

	// 목록 게시물 가져오기
	public List<ArticleBean> selectArticles(int limitStart) throws Exception {

		conn = DBConfig.getInstance().getConnection();

		// 3단계 - SQL 실행객체 생성
		stmt = conn.createStatement();

		// 4단계
		String sql  = "SELECT a.*, b.nick FROM `JBOARD_ARTICLE` AS a ";
	       	   sql += "JOIN `JBOARD_MEMBER` AS b ";
		       sql += "ON a.uid = b.uid ";
		       sql += "ORDER BY `seq` DESC "; // 최신 글 순서로 출력된다
		       sql += "LIMIT "+limitStart+", 10;";

		rs = stmt.executeQuery(sql);

		// 5단계
		List<ArticleBean> articles = new ArrayList<>();

		while (rs.next()) {

			ArticleBean ab = new ArticleBean();

			ab.setSeq(rs.getInt(1));
			ab.setParent(rs.getInt(2));
			ab.setComment(rs.getInt(3));
			ab.setCate(rs.getString(4));
			ab.setTitle(rs.getString(5));
			ab.setContent(rs.getString(6));
			ab.setFile(rs.getInt(7));
			ab.setHit(rs.getInt(8));
			ab.setUid(rs.getString(9));
			ab.setRegip(rs.getString(10));
			ab.setRdate(rs.getString(11));
			ab.setNick(rs.getString(12));

			articles.add(ab);
		}

		// 6단계
		close();

		return articles;
	}

	// 글 업데이트
	public void updateArticle(String title, String content, String seq) throws Exception {

		conn = DBConfig.getInstance().getConnection();

		// 3단계 - SQL 실행객체 생성
		String sql = "UPDATE `JBOARD_ARTICLE` SET `title`=?, `content`=? WHERE `seq`=?";
		psmt = conn.prepareStatement(sql);
		psmt.setString(1, title);
		psmt.setString(2, content);
		psmt.setString(3, seq);

		// 4단계
		psmt.executeUpdate();

		// 5단계

		// 6단계
		close();
	}

	// 조회수 업데이트
	public void updateHit(String seq) throws Exception {

		conn = DBConfig.getInstance().getConnection();

		// 3단계 - SQL 실행객체 생성
		stmt = conn.createStatement();

		// 4단계
		String sqlUpdate = "UPDATE `JBOARD_ARTICLE` SET `hit`=`hit`+1 WHERE `seq`=" + seq;
		stmt.executeUpdate(sqlUpdate);

		// 5단계

		// 6단계
		close();
	}

	// 글 삭제하기
	public void deleteArticle(String seq) throws Exception {

		conn = DBConfig.getInstance().getConnection();

		// 3단계 - SQL 실행객체 생성
		String sql = "DELETE FROM `JBOARD_ARTICLE` WHERE `seq`=?";
		psmt = conn.prepareStatement(sql);
		psmt.setString(1, seq);

		// 4단계
		psmt.executeUpdate();

		// 5단계

		// 6단계
		close();
	}

	public void close() throws Exception {
		if (rs != null)   rs.close();
		if (stmt != null) stmt.close();
		if (psmt != null) psmt.close();
		if (conn != null) conn.close();
	}
}
