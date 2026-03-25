const express = require('express');
const router = express.Router();
const articleController = require('../controllers/articleController');

// GET all articles
router.get('/articles', articleController.getAllArticles);

// GET single article
router.get('/articles/:id', articleController.getArticleById);

// POST new article
router.post('/articles', articleController.createArticle);

// PUT update article
router.put('/articles/:id', articleController.updateArticle);

// DELETE article
router.delete('/articles/:id', articleController.deleteArticle);

module.exports = router;
