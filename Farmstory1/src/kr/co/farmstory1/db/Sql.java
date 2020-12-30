package kr.co.farmstory1.db;

public class Sql {

	// 회원관련 SQL
	public static final String SELECT_TERMS = "SELECT * FROM `JBOARD_TERMS`";
	
	public static final String INSERT_USER = "INSERT INTO `JBOARD_MEMBER` SET "
										   + "`uid`=?,"
										   + "`pass`=PASSWORD(?),"
										   + "`name`=?,"
										   + "`nick`=?,"
										   + "`email`=?,"
										   + "`hp`=?,"
										   + "`zip`=?,"
										   + "`addr1`=?,"
										   + "`addr2`=?,"
										   + "`regip`=?,"
										   + "`rdate`=NOW();";
	
	public static final String SELECT_USER = "SELECT * FROM `JBOARD_MEMBER` "
										   + "WHERE "
										   + "`uid`=? AND `pass`=PASSWORD(?)";
			                               
	
	// 게시판관련 SQL	
	// 게시물 insert 하기
	public static final String INSERT_ARTICLE = "INSERT INTO `JBOARD_ARTICLE` SET " // 오타주의***** "INSERT"
											  + "`cate`=?,"
											  + "`title`=?,"
											  + "`content`=?,"
											  + "`file`=?,"
											  + "`uid`=?,"
											  + "`regip`=?,"
											  + "`rdate`=NOW()"; 
	
	public static final String SELECT_ARTICLES = "SELECT a.*,b.nick FROM `JBOARD_ARTICLE` AS a "
												+ "JOIN `JBOARD_MEMBER` AS b "
												+ "ON a.uid = b.uid "
												+ "WHERE `cate`=? AND `parent`=0 "
												+ "ORDER BY `seq` DESC "
												+ "LIMIT 10 ";

	public static final String SELECT_ARTICLE = "SELECT a.*, b.seq, b.oldName, b.download FROM `JBOARD_ARTICLE` AS a "
											  + "LEFT JOIN `JBOARD_FILE` AS b "
											  + "ON a.seq = b.parent "
											  + "WHERE a.seq=?";
	
	public static final String DELETE_ARTICLE = "DELETE FROM `JBOARD_ARTICLE` WHERE `seq`=?";
	
	
	// 첫화면 최신글 5개
	public static final String SELECT_LATEST1 = "(SELECT `seq`, `title`, `rdate` FROM `JBOARD_ARTICLE` WHERE `cate`='grow' ORDER BY `seq` DESC LIMIT 5) "
											  + "UNION "
											  + "(SELECT `seq`, `title`, `rdate` FROM `JBOARD_ARTICLE` WHERE `cate`='school' ORDER BY `seq` DESC LIMIT 5) "
											  + "UNION "
											  + "(SELECT `seq`, `title`, `rdate` FROM `JBOARD_ARTICLE` WHERE `cate`='story' ORDER BY `seq` DESC LIMIT 5) "
											  + "UNION "
											  + "(SELECT `seq`, `title`, `rdate` FROM `JBOARD_ARTICLE` WHERE `cate`='notice' ORDER BY `seq` DESC LIMIT 3)"
											  + "UNION "
											  + "(SELECT `seq`, `title`, `rdate` FROM `JBOARD_ARTICLE` WHERE `cate`='qna' ORDER BY `seq` DESC LIMIT 3)"
											  + "UNION "
											  + "(SELECT `seq`, `title`, `rdate` FROM `JBOARD_ARTICLE` WHERE `cate`='faq' ORDER BY `seq` DESC LIMIT 3)";
	
	
	// 기타 SQL
	
}