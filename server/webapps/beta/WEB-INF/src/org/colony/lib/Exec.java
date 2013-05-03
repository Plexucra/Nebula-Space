package org.colony.lib;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class Exec
{
	public static void exec(Connection c,String sql, int p) throws SQLException
	{
		PreparedStatement ps = c.prepareStatement(Sql.get(sql));
		ps.setInt(1, p);
		ps.executeUpdate();
		ps.close();
	}
}