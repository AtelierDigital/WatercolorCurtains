public class Trail {
  private IntList xTrailPositions;
  
  public void Initialize(){
    xTrailPositions = new IntList();
  }
  
  public void Update(int mouseX)
  {
    xTrailPositions.push(mouseX);
  }
  
}


 