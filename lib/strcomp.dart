
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
