#!/usr/bin/env ruby

require 'json'

class Track

  def initialize(segments, title=nil)
    @segments = segments
    @title = title
  end

  def get_dict()
    {
      type: "Feature",
      properties: {
        title: @title
      }.compact,
      geometry: {
        type: "MultiLineString",
        coordinates: @segments.map do |segment|
          segment.map do |point|
            point.to_a.compact
          end
        end
      }
    }.compact
  end
end

class Waypoint
  attr_reader :name, :type

  def initialize(args)
    @coords = args[:coords]
    @title = args[:name]
    @icon = args[:icon]
  end

  def get_dict()
    hash = {
     type: "Feature",
     geometry: {
        type: "Point",
        coordinates: @coords.values.compact
      },
     properties: {
        title: @title,
        icon: @icon
      }.compact
    }.compact
  end

end

class World
  def initialize(title, features)
    @title = title
    @features = features
  end

  def add_feature(f)
    @features.append(t)
  end

  def get_dict()
    {
      type: "FeatureCollection",
      features:
        @features.map do |feature|
          feature.get_dict
        end
    }
  end
end

def main()
  w = Waypoint.new(coords: Point.new(-121.5, 45.5, 30), name: "home", icon: "flag")
  w2 = Waypoint.new(coords: Point.new(-121.5, 45.6, nil), name: "store", icon: "dot")

  Point = Struct.new(:lon, :lat, :ele)

  ts1 = [
    Point.new(-122, 45),
    Point.new(-122, 46),
    Point.new(-121, 46)]
  ts2 = [
    Point.new(-121, 45),
    Point.new(-121, 46)]
  ts3 = [
    Point.new(-121, 45.5),
    Point.new(-122, 45.5)]

  t = Track.new([ts1, ts2], "track 1") # TODO second argument not descriptive
  t2 = Track.new([ts3], "track 2")

  world = World.new("My Data", [w, w2, t, t2])

  puts world.get_dict.to_json
end

if File.identical?(__FILE__, $0)
  main()
end
