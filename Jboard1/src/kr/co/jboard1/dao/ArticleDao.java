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
	
	
	// ��������ȣ �׷� ���ϱ�
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
	
	// ���� ������ �� ���۹�ȣ ���ϱ�
	public int getCurrentStartNum(int total, int limitStart) {
		return total - limitStart;
	}
	
	// ���� ������ ��ȣ ���ϱ�
	public int getCurrentPg(String pg) {
		int currentPg = 1;
		if(pg != null){
			currentPg = Integer.parseInt(pg);
		}
		return currentPg;
	}
	
	// �Խù� LIMIT ���۹�ȣ ���ϱ�
	public int getLimitStart(int currentPg) {
		int limitStart = (currentPg - 1) * 10;
		return limitStart;
	}
	
	// ��ü ������ ��ȣ ���ϱ�
	public int getLastPgNum(int total) {
		int lastPgNum = 0; //  page�� ����� �׷��� �ٸ� �̸����� pg
		
		if(total % 10 == 0){
			lastPgNum = total / 10;
		}else{
			lastPgNum = total / 10 + 1;
		}
	
		return lastPgNum;
	}
	
	// �� ������ȣ ���ϱ�
	public int selectCountArticle() throws Exception {
		// 1, 2�ܰ�
		conn = DBConfig.getInstance().getConnection();
		
		// 3�ܰ�
		stmt = conn.createStatement();
		
		// 4�ܰ�
		String sql = "SELECT COUNT(*) FROM `JBOARD_ARTICLE`"; // SELECT COUNT(*) = ������ʰ� COUNT ���� �ٷ� (*)�ٿ�����
		rs = stmt.executeQuery(sql);
		
		// 5�ܰ�
		int total = 0;
		if(rs.next()){
			total = rs.getInt(1);
		}
		
		// 6�ܰ�
		close();
		
		return total;
	}

	// ÷������
	public void insertFile(FileBean fb) throws Exception {
		// 1�ܰ�, 2�ܰ�, 3�ܰ�
		conn = DBConfig.getInstance().getConnection();
		stmt = conn.createStatement();
		
		// 4�ܰ�
		String sql  = "INSERT INTO `JBOARD_FILE` SET ";
			   sql += "`parent`="+fb.getParent()+",";
	 	       sql += "`oldName`='"+fb.getOldName()+"',";
		       sql += "`newName`='"+fb.getNewName()+"',";
		       sql += "`rdate`=NOW();";
		stmt.executeUpdate(sql);       

		// 5�ܰ�
		// 6�ܰ�
		close();
	}
	
	// �Խù� insert �ϱ�
	public int insertArticle(ArticleBean ab) throws Exception {

		conn = DBConfig.getInstance().getConnection();

		// 3�ܰ� - SQL ���ఴü ����
		stmt = conn.createStatement();

		// 4�ܰ�
		String sql  = "INSERT INTO `JBOARD_ARTICLE` SET "; // ��Ÿ����***** "INSERT"
		       sql += "`title`='" + ab.getTitle() + "',";
		       sql += "`content`='" + ab.getContent() + "',";
		       sql += "`file`=" + ab.getFile() + ",";
		       sql += "`uid`='" + ab.getUid() + "',";
		       sql += "`regip`='" + ab.getRegip() + "',";
		       sql += "`rdate`=NOW();";
		stmt.executeUpdate(sql);

		// 5�ܰ�

		// 6�ܰ�
		close();
		
		// �ο��� �۹�ȣ
		return selectMaxSeq();
	}

	// ÷������ ����
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
	
	// ��ȸ�� ��������
	// ������ ��������
	public ArticleBean selectArticle(String seq) throws Exception {
		conn = DBConfig.getInstance().getConnection();

		// 3�ܰ� - SQL ���ఴü ����
		stmt = conn.createStatement();

		// 4�ܰ�
		String sql  = "SELECT a.*, b.oldName, b.download FROM `JBOARD_ARTICLE` AS a ";
			   sql += "LEFT JOIN `JBOARD_FILE` AS b ";
		       sql += "ON a.seq = b.parent ";
		       sql += "WHERE a.seq="+seq; // `a.seq`�� Ʋ��ǥ��. 

		rs = stmt.executeQuery(sql);

		// 5�ܰ�
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

		// 6�ܰ�
		close();

		return ab;
	}

	// ��� �Խù� ��������
	public List<ArticleBean> selectArticles(int limitStart) throws Exception {

		conn = DBConfig.getInstance().getConnection();

		// 3�ܰ� - SQL ���ఴü ����
		stmt = conn.createStatement();

		// 4�ܰ�
		String sql  = "SELECT a.*, b.nick FROM `JBOARD_ARTICLE` AS a ";
	       	   sql += "JOIN `JBOARD_MEMBER` AS b ";
		       sql += "ON a.uid = b.uid ";
		       sql += "ORDER BY `seq` DESC "; // �ֽ� �� ������ ��µȴ�
		       sql += "LIMIT "+limitStart+", 10;";

		rs = stmt.executeQuery(sql);

		// 5�ܰ�
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

		// 6�ܰ�
		close();

		return articles;
	}

	// �� ������Ʈ
	public void updateArticle(String title, String content, String seq) throws Exception {

		conn = DBConfig.getInstance().getConnection();

		// 3�ܰ� - SQL ���ఴü ����
		String sql = "UPDATE `JBOARD_ARTICLE` SET `title`=?, `content`=? WHERE `seq`=?";
		psmt = conn.prepareStatement(sql);
		psmt.setString(1, title);
		psmt.setString(2, content);
		psmt.setString(3, seq);

		// 4�ܰ�
		psmt.executeUpdate();

		// 5�ܰ�

		// 6�ܰ�
		close();
	}

	// ��ȸ�� ������Ʈ
	public void updateHit(String seq) throws Exception {

		conn = DBConfig.getInstance().getConnection();

		// 3�ܰ� - SQL ���ఴü ����
		stmt = conn.createStatement();

		// 4�ܰ�
		String sqlUpdate = "UPDATE `JBOARD_ARTICLE` SET `hit`=`hit`+1 WHERE `seq`=" + seq;
		stmt.executeUpdate(sqlUpdate);

		// 5�ܰ�

		// 6�ܰ�
		close();
	}

	// �� �����ϱ�
	public void deleteArticle(String seq) throws Exception {

		conn = DBConfig.getInstance().getConnection();

		// 3�ܰ� - SQL ���ఴü ����
		String sql = "DELETE FROM `JBOARD_ARTICLE` WHERE `seq`=?";
		psmt = conn.prepareStatement(sql);
		psmt.setString(1, seq);

		// 4�ܰ�
		psmt.executeUpdate();

		// 5�ܰ�

		// 6�ܰ�
		close();
	}

	public void close() throws Exception {
		if (rs != null)   rs.close();
		if (stmt != null) stmt.close();
		if (psmt != null) psmt.close();
		if (conn != null) conn.close();
	}
}
