// Copyright(c) Szabó Bálint 2023-2024
// Usage controlled by the GPLv3 LICENSE file in the root of the repository

import 'dart:math';

int distance(String s, String t)
{
    String ts = s.toLowerCase();
    String tt = t.toLowerCase();
    int m = 0;
    for(int i = 0; i < tt.length - ts.length + 1; i++)
      {
        int ds = 0;
        for(int j = 0; j < ts.length; j++)
          {
            if(ts[j] == tt[i+j])
              {
                ds++;
              }
          }
        if(ds > m)
          m = ds;
      }
    return m;
}

/// Calculates the distance between two strings based on the QWERTY keyboard layout.
///
/// @param s1 The first string.
/// @param s2 The second string.
/// @return The distance between the two strings.
int qwertyDistance(String s1, String s2) {
  // Create a map of keyboard rows and columns for each character
  final keyboard = {
    'q': [0, 0], 'w': [0, 1], 'e': [0, 2], 'r': [0, 3], 't': [0, 4],
    'y': [0, 5], 'u': [0, 6], 'i': [0, 7], 'o': [0, 8], 'p': [0, 9],
    'a': [1, 0], 's': [1, 1], 'd': [1, 2], 'f': [1, 3], 'g': [1, 4],
    'h': [1, 5], 'j': [1, 6], 'k': [1, 7], 'l': [1, 8], ';': [1, 9],
    'z': [2, 0], 'x': [2, 1], 'c': [2, 2], 'v': [2, 3], 'b': [2, 4],
    'n': [2, 5], 'm': [2, 6], ',': [2, 7], '.': [2, 8], '/': [2, 9]
  };

  // Calculate the distance between each character pair
  int distance = 0;
  for (int i = 0; i < min(s1.length, s2.length); i++) {
    final c1 = s1[i].toLowerCase();
    final c2 = s2[i].toLowerCase();
    if (keyboard.containsKey(c1) && keyboard.containsKey(c2)) {
      final row1 = keyboard[c1]![0];
      final col1 = keyboard[c1]![1];
      final row2 = keyboard[c2]![0];
      final col2 = keyboard[c2]![1];
      distance += (row1 - row2).abs() + (col1 - col2).abs();
    }
  }

  // Add the length difference as a penalty
  distance += (s1.length - s2.length).abs();

  return distance;
}