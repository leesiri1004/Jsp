package kr.co.farmstory1.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import kr.co.farmstory1.bean.ArticleBean;
import kr.co.farmstory1.bean.FileBean;
import kr.co.farmstory1.db.DBConfig;

public class ArticleDao {

	private static ArticleDao instance = new ArticleDao();
	private ArticleDao() {}
	public static ArticleDao getInstance() {
		return instance;
	}

	// DB접속 관련 멤버객체
	private Connection conn			= null;
	private PreparedStatement psmt 	= null;
	private Statement stmt 			= null;
	private ResultSet rs 			= null;
	
	
	// 리스트 페이지처리 관련 메서드
	// 페이지 번호 그룹 구하기
	public int[] getPageGroup(int currentPg, int lastPgNum) {
		int groupCurrent = (int)Math.ceil(currentPg / 10.0);
		int groupStart = (groupCurrent - 1) * 10 + 1;
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
		String sql = "SELECT COUNT(*) FROM `JBOARD_ARTICLE` WHERE `parent`=0"; // SELECT COUNT(*) = 띄우지않고 COUNT 옆에 바로 (*)붙여야함
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

	
	// 첨부파일 관련메서드
	// 첨부파일 다운로드 기능
	public void updateFileDownload(String seq) throws Exception {
		// 1단계, 2단계, 3단계	
		conn = DBConfig.getInstance().getConnection();
		stmt = conn.createStatement();
		
		// 4단계
		String sql  = "UPDATE `JBOARD_FILE` SET `download`=`download`+1 ";
			   sql += "WHERE `seq`="+seq; // 파일번호
		stmt.executeUpdate(sql);

		// 5단계
		// 6단계
		close();
	}
	// 첨부파일 등록하기
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
	// 첨부파일 다운로드 시 oldName 기능
	public FileBean selectFile(String seq) throws Exception {
		conn = DBConfig.getInstance().getConnection();
		stmt = conn.createStatement();
		
		String sql = "SELECT * FROM `JBOARD_FILE` WHERE `seq`="+seq;
		rs = stmt.executeQuery(sql);
		
		FileBean fb = new FileBean();
		
		if (rs.next()) {
			fb.setSeq(rs.getInt(1));
			fb.setParent(rs.getInt(2));
			fb.setOldName(rs.getString(3));
			fb.setNewName(rs.getString(4));
			fb.setDownload(rs.getInt(5));
			fb.setRdate(rs.getString(6));
		}
		
		close();
		
		return fb;
	}
	
	
	// 게시글 관련 메서드
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
	// 부여된 글번호 (자동기능)
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
	// 댓글 업데이트
	public void updateArticleComment(String parent) throws Exception {
		conn = DBConfig.getInstance().getConnection();
		stmt = conn.createStatement();
		
		String sql  = "UPDATE `JBOARD_ARTICLE` SET `comment`=`comment`-1 ";
		       sql += "WHERE `seq`="+parent;
		
		stmt.executeUpdate(sql);
		
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
	
	// 댓글 관련 메서드
	// 원글 댓글 카운트 UPDATE
	public void updateCommentCount(String seq) throws Exception {
		conn = DBConfig.getInstance().getConnection();
		stmt = conn.createStatement();
		
		String sql  = "UPDATE `JBOARD_ARTICLE` SET `comment`=`comment`+1 ";
		       sql += "WHERE `seq`="+seq;
		
		stmt.executeUpdate(sql);
		
		close();
	}
	// 댓글 쓰기 기능
	public void insertComment(ArticleBean ab) throws Exception {
		conn = DBConfig.getInstance().getConnection();
		stmt = conn.createStatement();
		
		String sql  = "INSERT INTO `JBOARD_ARTICLE` SET ";
			   sql += "`parent`='"+ab.getParent()+"',";
			   sql += "`content`='"+ab.getContent()+"',";
			   sql += "`uid`='"+ab.getUid()+"',";
			   sql += "`regip`='"+ab.getRegip()+"',";
			   sql += "`rdate`=NOW();";
			   
		stmt.executeUpdate(sql);
		
		close();
	}
	// 댓글 목록 기능
	public List<ArticleBean> selectComments(String parent) throws Exception {
		conn = DBConfig.getInstance().getConnection();
		stmt = conn.createStatement();
		
		String sql  = "SELECT a.*, b.nick FROM `JBOARD_ARTICLE` AS a ";
			   sql += "JOIN `JBOARD_MEMBER` AS b ";
			   sql += "ON a.uid=b.uid ";
			   sql += "WHERE `parent`="+parent+" ";
			   sql += "ORDER BY `seq` ASC;";
		
		rs = stmt.executeQuery(sql);
		
		List<ArticleBean> comments = new ArrayList<ArticleBean>();
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

			comments.add(ab);
		}
			   
		close();
		
		return comments;
	}
	// 댓글삭제
	public void deleteComment(String seq) throws Exception {
		conn = DBConfig.getInstance().getConnection();
		stmt = conn.createStatement();

		// 3단계 - SQL 실행객체 생성
		String sql = "DELETE FROM `JBOARD_ARTICLE` WHERE `seq`="+seq;
		stmt.executeUpdate(sql);

		close();
	}
	// 댓글수정
	public int updateComment(String content, String seq) throws Exception {
		conn = DBConfig.getInstance().getConnection();
		stmt = conn.createStatement();

		// 3단계 - SQL 실행객체 생성
		String sql = "UPDATE `JBOARD_ARTICLE` SET `content`='"+content+"' WHERE `seq`="+seq;
		int result = stmt.executeUpdate(sql);

		close();
		
		return result;
	}
	
	
	// DB Access 객체 해제
	public void close() throws Exception {
		if (rs != null)   rs.close();
		if (stmt != null) stmt.close();
		if (psmt != null) psmt.close();
		if (conn != null) conn.close();
	}
}
