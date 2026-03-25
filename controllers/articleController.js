const pool = require('../config/database');

exports.getAllArticles = async (req, res) => {
  try {
    const connection = await pool.getConnection();
    const [rows] = await connection.query('SELECT * FROM articles');
    connection.release();
    
    res.json({
      success: true,
      data: rows,
      count: rows.length
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message
    });
  }
};

exports.getArticleById = async (req, res) => {
  try {
    const connection = await pool.getConnection();
    const [rows] = await connection.query(
      'SELECT * FROM articles WHERE id = ?',
      [req.params.id]
    );
    connection.release();
    
    if (rows.length === 0) {
      return res.status(404).json({ success: false, message: 'Article not found' });
    }
    
    res.json({ success: true, data: rows[0] });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

exports.createArticle = async (req, res) => {
  try {
    const { title, category, content, author, image_url } = req.body;
    const connection = await pool.getConnection();
    
    const [result] = await connection.query(
      'INSERT INTO articles (title, category, content, author, image_url, created_at) VALUES (?, ?, ?, ?, ?, NOW())',
      [title, category, content, author, image_url]
    );
    connection.release();
    
    res.status(201).json({
      success: true,
      data: { id: result.insertId, ...req.body }
    });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

exports.updateArticle = async (req, res) => {
  try {
    const { title, category, content, author, image_url } = req.body;
    const connection = await pool.getConnection();
    
    await connection.query(
      'UPDATE articles SET title=?, category=?, content=?, author=?, image_url=? WHERE id=?',
      [title, category, content, author, image_url, req.params.id]
    );
    connection.release();
    
    res.json({
      success: true,
      data: { id: req.params.id, ...req.body }
    });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

exports.deleteArticle = async (req, res) => {
  try {
    const connection = await pool.getConnection();
    await connection.query('DELETE FROM articles WHERE id=?', [req.params.id]);
    connection.release();
    
    res.json({ success: true, message: 'Article deleted' });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};
