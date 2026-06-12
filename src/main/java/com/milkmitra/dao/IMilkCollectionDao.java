package com.milkmitra.dao;

import java.sql.SQLException;
import java.util.List;

import com.milkmitra.model.Collection;

public interface IMilkCollectionDao
{
	//1. Feature for Milk Collection Entry...
	String addCollection(Collection collection) throws SQLException;

	// MilkCollectionReport----------------------------------------------------------------
	
}
