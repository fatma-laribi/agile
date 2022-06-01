/* eslint-disable prettier/prettier */
import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { count } from 'console';
import { User } from 'src/user/entities/user.entity';
import { Repository } from 'typeorm';
import { CreateRecommendationDto } from './dto/create-recommendation.dto';
import { UpdateRecommendationDto } from './dto/update-recommendation.dto';
import { Recommendation } from './entities/recommendation.entity';

@Injectable()
export class RecommendationService {
  constructor(
    @InjectRepository(Recommendation)
    private readonly recommendationRepository: Repository<Recommendation>,
    @InjectRepository(User)
    private readonly userRepository: Repository<User>,
  ) {}
  async create(createRecommendationDto: CreateRecommendationDto) {
    const newRecommendation: Recommendation= await this.recommendationRepository.save(createRecommendationDto);
    const user:User = await this.userRepository.findOne(createRecommendationDto.receiver);
    const count= await this.recommendationRepository.findAndCount({receiver:createRecommendationDto.receiver})["count"];
    const nb:number=count;
    user.rating= (user.rating*(nb-1)+createRecommendationDto.rating)/nb;
    this.userRepository.update(user.username,{...user});
//update user
    return newRecommendation;
  }

  findAll() {
    return `This action returns all recommendation`;
  }

  findOne(id: number) {
    return `This action returns a #${id} recommendation`;
  }

  update(id: number, updateRecommendationDto: UpdateRecommendationDto) {
    return `This action updates a #${id} recommendation`;
  }

  remove(id: number) {
    return `This action removes a #${id} recommendation`;
  }
}
