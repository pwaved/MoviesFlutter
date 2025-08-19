import express from 'express';
import { getFavorites, addFavorite, removeFavorite } from '../controllers/favoritesController.js';
import authMiddleware from '../middleware/authMiddleware.js';

const router = express.Router();

router.use(authMiddleware);

router.get('/:userId/favorites', getFavorites);
router.post('/:userId/favorites', addFavorite);
router.delete('/:userId/favorites/:movieId', removeFavorite);

export default router;