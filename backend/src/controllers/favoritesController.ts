import { Request, Response } from 'express';
import Favorite from '../models/favorite.js';

// Estendendo a interface Request do Express para incluir userId
interface AuthenticatedRequest extends Request {
  userId?: number;
}

export const getFavorites = async (req: AuthenticatedRequest, res: Response) => {
  const userId = req.userId;
  if (parseInt(req.params.userId, 10) !== userId) {
    return res.status(403).json({ error: "Acesso negado." });
  }

  try {
    const favorites = await Favorite.findAll({
      where: { user_id: userId },
      attributes: ['movie_id'],
    });
    const movieIds = favorites.map(fav => fav.movie_id);
    res.json(movieIds);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Erro ao buscar favoritos.' });
  }
};

export const addFavorite = async (req: AuthenticatedRequest, res: Response) => {
  const userId = req.userId;
  const { movieId } = req.body;
  if (parseInt(req.params.userId, 10) !== userId) {
    return res.status(403).json({ error: "Acesso negado." });
  }
  if (!movieId) {
    return res.status(400).json({ error: 'O ID do filme é obrigatório.' });
  }

  try {
    const [favorite, created] = await Favorite.findOrCreate({
      where: { user_id: userId, movie_id: movieId },
    });

    if (!created) {
      return res.status(409).json({ message: 'Filme já está nos favoritos.' });
    }
    res.status(201).json({ message: 'Filme adicionado aos favoritos.' });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Erro ao adicionar favorito.' });
  }
};

export const removeFavorite = async (req: AuthenticatedRequest, res: Response) => {
  const userId = req.userId;
  const { movieId } = req.params;
  if (parseInt(req.params.userId, 10) !== userId) {
    return res.status(403).json({ error: "Acesso negado." });
  }

  try {
    const deletedCount = await Favorite.destroy({
      where: { user_id: userId, movie_id: movieId },
    });
    if (deletedCount === 0) {
      return res.status(404).json({ error: 'Favorito não encontrado.' });
    }
    res.status(200).json({ message: 'Filme removido dos favoritos.' });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Erro ao remover favorito.' });
  }
};