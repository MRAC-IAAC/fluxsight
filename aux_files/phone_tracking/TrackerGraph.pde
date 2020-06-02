public class TrackerGraph {
  public int id = 0;
  public PVector[] data;
  public PGraphics pg;

  private int maxSamples;

  public float minValue = -10;
  public float maxValue = 10;
  
  public int color0 = 0xFFFF0000;
  public int color1 = 0xFF00FF00;
  public int color2 = 0xFF0000FF;

  public TrackerGraph(int maxSamples) {
    this.data = new PVector[maxSamples];
    for (int i = 0; i < maxSamples; i++) {
      data[i] = new PVector();
    }

    this.maxSamples = maxSamples;

    pg = createGraphics(400, 400);
  }

  public void addSample(PVector sample) {
    data[id] = sample.copy();

    id = (id + 1) % maxSamples;
  }

  public void draw() {

    pg.beginDraw();
    pg.clear();
    pg.noFill();
    
    pg.strokeWeight(1);

    pg.stroke(50);
    pg.rect(0, 0, pg.width, pg.height);

    pg.stroke(100);
    pg.line(0, pg.height / 2, width, pg.height / 2);
    
    pg.strokeWeight(2);

    pg.stroke(color0);
    pg.beginShape();
    for (int i = 0; i < maxSamples; i++) {
      int n = (i + id) % maxSamples;
      pg.vertex(map(i, 0, maxSamples, 0, pg.width), pg.height - map(data[n].x, minValue, maxValue, 0, pg.height));
    }
    pg.endShape();

    pg.stroke(color1);
    pg.beginShape();
    for (int i = 0; i < maxSamples; i++) {
      int n = (i + id) % maxSamples;
      pg.vertex(map(i, 0, maxSamples, 0, pg.width), pg.height - map(data[n].y, minValue, maxValue, 0, pg.height));
    }
    pg.endShape();

    pg.stroke(color2);
    pg.beginShape();
    for (int i = 0; i < maxSamples; i++) {
      int n = (i + id) % maxSamples;
      pg.vertex(map(i, 0, maxSamples, 0, pg.width), pg.height - map(data[n].z, minValue, maxValue, 0, pg.height));
    }
    pg.endShape();


    pg.endDraw();
  }

  public PVector getAverage() {
    PVector average = new PVector();
    for (int i = 0; i < maxSamples; i++) {
      average.add(data[i]);
    }

    average.div(maxSamples);

    return(average);
  }

  public PVector getRecentAverage(int n) {
    PVector output = new PVector();
    for (int i = 0; i < n; i++) {
      int newId = id - (i + 1);
      if (newId < 0) {
        newId += maxSamples;
      }
      output.add(data[newId]);
    }
    output.div(n);
    return(output);
  }
  
  public PVector getRecentWeightedAverage(int n) {
    float weightTotal = 0;
    float weight = 0.5;
    float factor = 0.5;
    PVector output = new PVector();
    for (int i = 0; i < n; i++) {
      int newId = id - (i + 1);
      if (newId < 0) {
        newId += maxSamples;
      }
      output.add(PVector.mult(data[newId],weight));
      weightTotal += weight;
      weight *= factor;
    }
    output.div(weightTotal);
    return(output);
  }
}
