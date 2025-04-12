const express = require('express');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const User = require('../models/User');
const router = express.Router();

// Register User
router.post('/register', async (req, res) => {
  const { name, email, phone, password } = req.body;
  try {
    const user = new User({ name, email, phone, password });
    await user.save();
    res.status(201).json({ msg: 'User created successfully!' });
  } catch (err) {
    res.status(400).json({ msg: 'Failed to create user: ' + err.message });
  }
});

// Login User
router.post('/login', async (req, res) => {
  const { email, password } = req.body;
  try {
    const user = await User.findOne({ email });
    if (!user || !bcrypt.compareSync(password, user.password)) {
      return res.status(400).json({ msg: 'Invalid credentials' });
    }

    const token = jwt.sign({ userId: user._id }, process.env.JWT_SECRET);
    res.status(200).json({ token });
  } catch (err) {
    res.status(500).json({ msg: 'Login failed: ' + err.message });
  }
});

// Google Sign-In Route (Post)
router.post('/google', async (req, res) => {
  const { name, email, googleId } = req.body;
  try {
    let user = await User.findOne({ googleId });
    if (!user) {
      user = new User({ name, email, googleId });
      await user.save();
    }
    
    const token = jwt.sign({ userId: user._id }, process.env.JWT_SECRET);
    res.status(200).json({ token });
  } catch (err) {
    res.status(500).json({ msg: 'Google Sign-In failed: ' + err.message });
  }
});

module.exports = router;
